package com.signify.hue.flutterreactiveble.ble

import android.bluetooth.BluetoothDevice.BOND_BONDING
import android.bluetooth.BluetoothGattCharacteristic
import android.content.Context
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.VisibleForTesting
import com.polidea.rxandroidble2.LogConstants
import com.polidea.rxandroidble2.LogOptions
import com.polidea.rxandroidble2.NotificationSetupMode
import com.polidea.rxandroidble2.RxBleClient
import com.polidea.rxandroidble2.RxBleConnection
import com.polidea.rxandroidble2.RxBleDevice
import com.polidea.rxandroidble2.RxBleDeviceServices
import com.polidea.rxandroidble2.scan.ScanFilter
import com.polidea.rxandroidble2.scan.ScanSettings
import com.signify.hue.flutterreactiveble.ble.extensions.writeCharWithResponse
import com.signify.hue.flutterreactiveble.ble.extensions.writeCharWithoutResponse
import com.signify.hue.flutterreactiveble.converters.extractManufacturerData
import com.signify.hue.flutterreactiveble.model.ScanMode
import com.signify.hue.flutterreactiveble.model.toScanSettings
import com.signify.hue.flutterreactiveble.utils.Duration
import com.signify.hue.flutterreactiveble.utils.toBleState
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.subjects.BehaviorSubject
import java.util.UUID
import java.util.concurrent.TimeUnit
import kotlin.collections.component1
import kotlin.collections.component2

@Suppress("TooManyFunctions")
open class ReactiveBleClient(private val context: Context) : BleClient {
    private val connectionQueue = ConnectionQueue()
    private val allConnections = CompositeDisposable()

    companion object {
        // this needs to be in companion update since backgroundisolates respawn the eventchannels
        // Fix for https://github.com/PhilipsHue/flutter_reactive_ble/issues/277
        private val connectionUpdateBehaviorSubject: BehaviorSubject<ConnectionUpdate> =
            BehaviorSubject.create()

        lateinit var rxBleClient: RxBleClient
            internal set
        internal var activeConnections = mutableMapOf<String, DeviceConnector>()
    }

    override val connectionUpdateSubject: BehaviorSubject<ConnectionUpdate>
        get() = connectionUpdateBehaviorSubject

    override fun initializeClient() {
        activeConnections = mutableMapOf()
        rxBleClient = RxBleClient.create(context)
    }

    /*yes spread operator is not performant but after kotlin v1.60 it is less bad and it is also the
    recommended way to call varargs in java https://kotlinlang.org/docs/reference/java-interop.html#java-varargs
    */
    @Suppress("SpreadOperator")
    override fun scanForDevices(
        services: List<ParcelUuid>,
        scanMode: ScanMode,
        requireLocationServicesEnabled: Boolean
    ): Observable<ScanInfo> {

        val filters = services.map { service ->
            ScanFilter.Builder()
                .setServiceUuid(service)
                .build()
        }.toTypedArray()

        return rxBleClient.scanBleDevices(
            ScanSettings.Builder()
                .setScanMode(scanMode.toScanSettings())
                .setLegacy(false)
                .setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES)
                .setShouldCheckLocationServicesState(requireLocationServicesEnabled)
                .build(),
            *filters
        )
            .map { result ->
                ScanInfo(result.bleDevice.macAddress, result.scanRecord.deviceName
                    ?: result.bleDevice.name ?: "",
                    result.rssi,
                    result.scanRecord.serviceData?.mapKeys { it.key.uuid } ?: emptyMap(),
                    result.scanRecord.serviceUuids?.map { it.uuid } ?: emptyList(),
                    extractManufacturerData(result.scanRecord.manufacturerSpecificData))
            }
    }

    override fun connectToDevice(deviceId: String, timeout: Duration) {
        allConnections.add(getConnection(deviceId, timeout)
            .subscribe({ result ->
                when (result) {
                    is EstablishedConnection -> {
                    }
                    is EstablishConnectionFailure -> {
                        connectionUpdateBehaviorSubject.onNext(
                            ConnectionUpdateError(
                                deviceId,
                                result.errorMessage
                            )
                        )
                    }
                }
            }, { error ->
                connectionUpdateBehaviorSubject.onNext(
                    ConnectionUpdateError(
                        deviceId, error?.message
                            ?: "unknown error"
                    )
                )
            })
        )
    }

    override fun disconnectDevice(deviceId: String) {
        activeConnections[deviceId]?.disconnectDevice(deviceId)
        activeConnections.remove(deviceId)
    }

    override fun disconnectAllDevices() {
        activeConnections.forEach { (device, connector) -> connector.disconnectDevice(device) }
        allConnections.dispose()
    }

    override fun clearGattCache(deviceId: String): Completable =
        activeConnections[deviceId]?.let(DeviceConnector::clearGattCache)
            ?: Completable.error(IllegalStateException("Device is not connected"))

    override fun discoverServices(deviceId: String): Single<RxBleDeviceServices> {

        return getConnection(deviceId).flatMapSingle { connectionResult ->
            when (connectionResult) {
                is EstablishedConnection ->
                    if (rxBleClient.getBleDevice(connectionResult.deviceId).bluetoothDevice.bondState == BOND_BONDING) {
                        Single.error(Exception("Bonding is in progress wait for bonding to be finished before executing more operations on the device"))
                    } else {
                        connectionResult.rxConnection.discoverServices()
                    }
                is EstablishConnectionFailure -> Single.error(Exception(connectionResult.errorMessage))
            }
        }.firstOrError()
    }

    override fun readCharacteristic(
        deviceId: String,
        characteristic: UUID
    ): Single<CharOperationResult> =
        getConnection(deviceId).flatMapSingle<CharOperationResult> { connectionResult ->
            when (connectionResult) {
                is EstablishedConnection ->
                    connectionResult.rxConnection.readCharacteristic(characteristic)
                        /*
                        On Android7 the ble stack frequently gives incorrectly
                        the error GAT_AUTH_FAIL(137) when reading char that will establish
                        the bonding with the peripheral. By retrying the operation once we
                        deviate between this flaky one time error and real auth failed cases
                        */
                        .retry(1) { Build.VERSION.SDK_INT < Build.VERSION_CODES.O }
                        .map { value ->
                            CharOperationSuccessful(deviceId, value.asList())
                        }
                is EstablishConnectionFailure ->
                    Single.just(
                        CharOperationFailed(
                            deviceId,
                            "failed to connect ${connectionResult.errorMessage}"
                        )
                    )
            }
        }.first(CharOperationFailed(deviceId, "read char failed"))

    override fun writeCharacteristicWithResponse(
        deviceId: String,
        characteristic: UUID,
        value: ByteArray
    ): Single<CharOperationResult> =
        executeWriteOperation(
            deviceId,
            characteristic,
            value,
            RxBleConnection::writeCharWithResponse
        )

    override fun writeCharacteristicWithoutResponse(
        deviceId: String,
        characteristic: UUID,
        value: ByteArray
    ): Single<CharOperationResult> =

        executeWriteOperation(
            deviceId,
            characteristic,
            value,
            RxBleConnection::writeCharWithoutResponse
        )

    override fun setupNotification(deviceId: String, characteristic: UUID): Observable<ByteArray> {
        return getConnection(deviceId)
            .flatMap { deviceConnection ->
                setupNotificationOrIndication(
                    deviceConnection,
                    characteristic
                )
            }
            // now we have setup the subscription and we want the actual value
            .flatMap { notificationObservable ->
                notificationObservable
            }
    }

    override fun negotiateMtuSize(deviceId: String, size: Int): Single<MtuNegotiateResult> =
        getConnection(deviceId).flatMapSingle { connectionResult ->
            when (connectionResult) {
                is EstablishedConnection -> connectionResult.rxConnection.requestMtu(size)
                    .map { value -> MtuNegotiateSuccesful(deviceId, value) }

                is EstablishConnectionFailure ->
                    Single.just(
                        MtuNegotiateFailed(
                            deviceId,
                            "failed to connect ${connectionResult.errorMessage}"
                        )
                    )
            }
        }.first(MtuNegotiateFailed(deviceId, "negotiate mtu timed out"))

    override fun observeBleStatus(): Observable<BleStatus> = rxBleClient.observeStateChanges()
        .startWith(rxBleClient.state)
        .map { it.toBleState() }

    @VisibleForTesting
    internal open fun createDeviceConnector(device: RxBleDevice, timeout: Duration) =
        DeviceConnector(device, timeout, connectionUpdateBehaviorSubject::onNext, connectionQueue)

    private fun getConnection(
        deviceId: String,
        timeout: Duration = Duration(0, TimeUnit.MILLISECONDS)
    ): Observable<EstablishConnectionResult> {
        val device = rxBleClient.getBleDevice(deviceId)
        val connector =
            activeConnections.getOrPut(deviceId) { createDeviceConnector(device, timeout) }

        return connector.connection
    }

    private fun executeWriteOperation(
        deviceId: String,
        characteristic: UUID,
        value: ByteArray,
        bleOperation: RxBleConnection.(characteristic: UUID, value: ByteArray) -> Single<ByteArray>
    ): Single<CharOperationResult> {
        return getConnection(deviceId)
            .flatMapSingle<CharOperationResult> { connectionResult ->
                when (connectionResult) {
                    is EstablishedConnection -> {
                        connectionResult.rxConnection.bleOperation(characteristic, value)
                            .map { value -> CharOperationSuccessful(deviceId, value.asList()) }
                    }
                    is EstablishConnectionFailure -> {
                        Single.just(
                            CharOperationFailed(
                                deviceId,
                                "failed to connect ${connectionResult.errorMessage}"
                            )
                        )
                    }
                }
            }.first(CharOperationFailed(deviceId, "Writechar timed-out"))
    }

    private fun setupNotificationOrIndication(
        deviceConnection: EstablishConnectionResult,
        characteristic: UUID
    ): Observable<Observable<ByteArray>> =

        when (deviceConnection) {
            is EstablishedConnection -> {

                if (rxBleClient.getBleDevice(deviceConnection.deviceId).bluetoothDevice.bondState == BOND_BONDING) {
                    Observable.error(Exception("Bonding is in progress wait for bonding to be finished before executing more operations on the device"))
                } else {
                    deviceConnection.rxConnection.discoverServices()
                        .flatMap { deviceServices -> deviceServices.getCharacteristic(characteristic) }
                        .flatMapObservable { char ->
                            val mode = if (char.descriptors.isEmpty()) {
                                NotificationSetupMode.COMPAT
                            } else {
                                NotificationSetupMode.DEFAULT
                            }

                            if ((char.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY) > 0) {
                                deviceConnection.rxConnection.setupNotification(
                                    characteristic,
                                    mode
                                )
                            } else {
                                deviceConnection.rxConnection.setupIndication(characteristic, mode)
                            }
                        }
                }
            }
            is EstablishConnectionFailure -> {
                Observable.just(Observable.empty())
            }
        }

    override fun requestConnectionPriority(
        deviceId: String,
        priority: ConnectionPriority
    ): Single<RequestConnectionPriorityResult> =
        getConnection(deviceId).switchMapSingle<RequestConnectionPriorityResult> { connectionResult ->
            when (connectionResult) {
                is EstablishedConnection ->
                    connectionResult.rxConnection.requestConnectionPriority(
                        priority.code,
                        2,
                        TimeUnit.SECONDS
                    )
                        .toSingle {
                            RequestConnectionPrioritySuccess(deviceId)
                        }
                is EstablishConnectionFailure -> Single.fromCallable {
                    RequestConnectionPriorityFailed(deviceId, connectionResult.errorMessage)
                }
            }
        }.first(RequestConnectionPriorityFailed(deviceId, "Unknown failure"))

    // enable this for extra debug output on the android stack
    private fun enableDebugLogging() = RxBleClient
        .updateLogOptions(
            LogOptions.Builder().setLogLevel(LogConstants.VERBOSE)
                .setMacAddressLogSetting(LogConstants.MAC_ADDRESS_FULL)
                .setUuidsLogSetting(LogConstants.UUIDS_FULL)
                .setShouldLogAttributeValues(true)
                .build()
        )
}
