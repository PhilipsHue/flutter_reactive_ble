package com.signify.hue.flutterreactiveble.ble

import android.bluetooth.BluetoothGattCharacteristic
import android.content.Context
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.VisibleForTesting
import com.polidea.rxandroidble2.LogConstants
import com.polidea.rxandroidble2.LogOptions
import com.polidea.rxandroidble2.RxBleClient
import com.polidea.rxandroidble2.RxBleConnection
import com.polidea.rxandroidble2.RxBleDevice
import com.polidea.rxandroidble2.scan.ScanFilter
import com.polidea.rxandroidble2.scan.ScanSettings
import com.signify.hue.flutterreactiveble.ble.extensions.writeCharWithResponse
import com.signify.hue.flutterreactiveble.ble.extensions.writeCharWithoutResponse
import com.signify.hue.flutterreactiveble.model.ScanMode
import com.signify.hue.flutterreactiveble.model.toScanSettings
import com.signify.hue.flutterreactiveble.utils.Duration
import com.signify.hue.flutterreactiveble.utils.toBleState
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.subjects.BehaviorSubject
import timber.log.Timber
import java.util.UUID
import java.util.concurrent.TimeUnit

@Suppress("TooManyFunctions")
open class ReactiveBleClient(private val context: Context) : BleClient {
    private val connectionQueue = ConnectionQueue()
    private val allConnections = CompositeDisposable()

    override val connectionUpdateSubject: BehaviorSubject<ConnectionUpdate> = BehaviorSubject.create()

    companion object {

        lateinit var rxBleClient: RxBleClient
            internal set
        internal lateinit var activeConnections: MutableMap<String, DeviceConnector>
    }

    override fun initializeClient() {
        ReactiveBleClient.Companion.activeConnections = mutableMapOf()
        ReactiveBleClient.Companion.rxBleClient = RxBleClient.create(context)

        Timber.d("Created bleclient")
    }

    override fun scanForDevices(service: ParcelUuid, scanMode: ScanMode): Observable<ScanInfo> {
        return ReactiveBleClient.Companion.rxBleClient.scanBleDevices(
                ScanSettings.Builder()
                        .setScanMode(scanMode.toScanSettings())
                        .setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES)
                        .build(),
                ScanFilter.Builder()
                        .setServiceUuid(service)
                        .build()
        )
                .map { result ->
                    ScanInfo(result.bleDevice.macAddress, result.bleDevice.name
                            ?: "",
                            result.rssi, result.scanRecord.serviceData.mapKeys { it.key.uuid })
                }
    }

    override fun connectToDevice(deviceId: String, timeout: Duration) {
        allConnections.add(getConnection(deviceId, timeout)
                .subscribe({ result ->
                    when (result) {
                        is EstablishedConnection -> {
                            Timber.d("Connection established for ${result.deviceId}")
                        }
                        is EstablishConnectionFailure -> {
                            Timber.d("Connect ${result.deviceId} fails: ${result.errorMessage}")
                            connectionUpdateSubject.onNext(ConnectionUpdateError(deviceId, result.errorMessage))
                        }
                    }
                }, { error ->
                    connectionUpdateSubject.onNext(ConnectionUpdateError(deviceId, error?.message
                            ?: "unknown error"))
                }))
    }

    override fun disconnectDevice(deviceId: String) {
        ReactiveBleClient.Companion.activeConnections[deviceId]?.disconnectDevice()
        ReactiveBleClient.Companion.activeConnections.remove(deviceId)
    }

    override fun disconnectAllDevices() {
        ReactiveBleClient.Companion.activeConnections.forEach { (_, connector) -> connector.disconnectDevice() }
        allConnections.dispose()
    }

    override fun clearGattCache(deviceId: String): Completable =
            ReactiveBleClient.Companion.activeConnections[deviceId]?.let(DeviceConnector::clearGattCache)
                    ?: Completable.error(IllegalStateException("Device is not connected"))

    override fun readCharacteristic(deviceId: String, characteristic: UUID): Single<CharOperationResult> =
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
                                CharOperationFailed(deviceId,
                                        "failed to connect ${connectionResult.errorMessage}"))
                }
            }.first(CharOperationFailed(deviceId, "read char failed"))

    override fun writeCharacteristicWithResponse(
            deviceId: String,
            characteristic: UUID,
            value: ByteArray
    ): Single<CharOperationResult> =
            executeWriteOperation(deviceId, characteristic, value, RxBleConnection::writeCharWithResponse)

    override fun writeCharacteristicWithoutResponse(
            deviceId: String,
            characteristic: UUID,
            value: ByteArray
    ): Single<CharOperationResult> =

            executeWriteOperation(deviceId, characteristic, value, RxBleConnection::writeCharWithoutResponse)

    override fun setupNotification(deviceId: String, characteristic: UUID): Observable<ByteArray> {
        return getConnection(deviceId)
                .flatMap { deviceConnection -> setupNotificationOrIndication(deviceConnection, characteristic) }
                // now we have setup the subscription and we want the actual value
                .doOnNext { Timber.d("subscription established") }
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
                        Single.just(MtuNegotiateFailed(deviceId,
                                "failed to connect ${connectionResult.errorMessage}"))
                }
            }.first(MtuNegotiateFailed(deviceId, "negotiate mtu timed out"))

    override fun observeBleStatus(): Observable<BleStatus> = ReactiveBleClient.Companion.rxBleClient.observeStateChanges()
            .startWith(ReactiveBleClient.Companion.rxBleClient.state)
            .map { it.toBleState() }

    @VisibleForTesting
    internal open fun createDeviceConnector(device: RxBleDevice, timeout: Duration) =
            DeviceConnector(device, timeout, connectionUpdateSubject::onNext, connectionQueue)

    private fun getConnection(
            deviceId: String,
            timeout: Duration = Duration(0, TimeUnit.MILLISECONDS)
    ): Observable<EstablishConnectionResult> {
        val device = ReactiveBleClient.Companion.rxBleClient.getBleDevice(deviceId)
        val connector = ReactiveBleClient.Companion.activeConnections.getOrPut(deviceId) { createDeviceConnector(device, timeout) }

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
                            Timber.d("Failed conn for write ")
                            Single.just(
                                    CharOperationFailed(deviceId,
                                            "failed to connect ${connectionResult.errorMessage}"))
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
                    deviceConnection.rxConnection.discoverServices()
                            .flatMap { deviceServices -> deviceServices.getCharacteristic(characteristic) }
                            .flatMapObservable { char ->
                                if ((char.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY) > 0) {
                                    deviceConnection.rxConnection.setupNotification(characteristic)
                                } else {
                                    deviceConnection.rxConnection.setupIndication(characteristic)
                                }
                            }
                }
                is EstablishConnectionFailure -> {
                    Observable.just(Observable.empty<ByteArray>())
                }
            }

    override fun requestConnectionPriority(
            deviceId: String,
            priority: ConnectionPriority
    ): Single<RequestConnectionPriorityResult> =
            getConnection(deviceId).switchMapSingle<RequestConnectionPriorityResult> { connectionResult ->
                when (connectionResult) {
                    is EstablishedConnection ->
                        connectionResult.rxConnection.requestConnectionPriority(priority.code, 2, TimeUnit.SECONDS)
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
            .updateLogOptions(LogOptions.Builder().setLogLevel(LogConstants.VERBOSE)
                    .setMacAddressLogSetting(LogConstants.MAC_ADDRESS_FULL)
                    .setUuidsLogSetting(LogConstants.UUIDS_FULL)
                    .setShouldLogAttributeValues(true)
                    .build())
}
