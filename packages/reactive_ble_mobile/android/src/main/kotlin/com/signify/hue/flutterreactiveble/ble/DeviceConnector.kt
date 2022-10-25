package com.signify.hue.flutterreactiveble.ble

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothProfile
import androidx.annotation.VisibleForTesting
import com.polidea.rxandroidble2.RxBleConnection
import com.polidea.rxandroidble2.RxBleCustomOperation
import com.polidea.rxandroidble2.RxBleDevice
import com.signify.hue.flutterreactiveble.model.ConnectionState
import com.signify.hue.flutterreactiveble.model.toConnectionState
import com.signify.hue.flutterreactiveble.utils.Duration
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.disposables.Disposable
import io.reactivex.subjects.BehaviorSubject
import java.util.concurrent.TimeUnit
import android.content.Context
import android.util.Log

@SuppressLint("MissingPermission")
internal class DeviceConnector(
    private val context: Context,
    private val device: RxBleDevice,
    private val connectionTimeout: Duration,
    private val updateListeners: (update: ConnectionUpdate) -> Unit,
    private val connectionQueue: ConnectionQueue,
    private val forcedBond: Boolean,
    private val autoConnect: Boolean,
) {

    companion object {
        private const val minTimeMsBeforeDisconnectingIsAllowed = 200L
        private const val delayMsAfterClearingCache = 300L
    }

    private var bonded = false
    private val connectDeviceSubject = BehaviorSubject.create<EstablishConnectionResult>()

    private var timestampEstablishConnection: Long = 0

    @VisibleForTesting
    internal var connectionDisposable: Disposable? = null

    private val lazyConnection = lazy {
        connectionDisposable = establishConnection(device)
        connectDeviceSubject
    }

    private val currentConnection: EstablishConnectionResult?
        get() = if (lazyConnection.isInitialized()) connection.value else null

    internal val connection by lazyConnection

    private val connectionStatusUpdates by lazy {
        device.observeConnectionStateChanges()
            .startWith(device.connectionState)
            .map<ConnectionUpdate> {
                ConnectionUpdateSuccess(device.macAddress, it.toConnectionState().code)
            }
            .onErrorReturn {
                ConnectionUpdateError(
                    device.macAddress, it.message
                        ?: "Unknown error"
                )
            }
            .subscribe {
                if (!forcedBond) {
                    updateListeners.invoke(it)
                    return@subscribe
                }
                if (it is ConnectionUpdateSuccess && it.connectionState == ConnectionState.CONNECTED.code) {
                    if (device.bluetoothDevice
                            .bondState == BluetoothDevice.BOND_BONDED
                    )
                        updateListeners.invoke(it)
                    else {
                        val bondState: Int = device.bluetoothDevice.bondState
                        if (bondState != BluetoothDevice.BOND_BONDING) {
                            device.bluetoothDevice.createBond()
                        }
                        Observable.interval(5, TimeUnit.SECONDS)
                            .take(3)
                            .subscribe {
                                if (!bonded && device.bluetoothDevice
                                        .bondState == BluetoothDevice.BOND_BONDED
                                ) {
                                    bonded = true
                                    updateListeners.invoke(
                                        ConnectionUpdateSuccess(
                                            device.macAddress,
                                            ConnectionState.CONNECTED.code
                                        )
                                    )
                                }
                            }
                    }
                }
            }
    }

    internal fun disconnectDevice(deviceId: String) {
        val diff = System.currentTimeMillis() - timestampEstablishConnection

        /*
        in order to prevent Android from ignoring disconnects we add a delay when we try to
        disconnect to quickly after establishing connection. https://issuetracker.google.com/issues/37121223
         */
        if (diff < minTimeMsBeforeDisconnectingIsAllowed) {
            Single.timer(
                minTimeMsBeforeDisconnectingIsAllowed - diff,
                TimeUnit.MILLISECONDS
            )
                .doFinally {
                    sendDisconnectedUpdate(deviceId)
                    disposeSubscriptions()
                }.subscribe()
        } else {
            sendDisconnectedUpdate(deviceId)
            disposeSubscriptions()
        }
    }

    private fun sendDisconnectedUpdate(deviceId: String) {
        updateListeners(ConnectionUpdateSuccess(deviceId, ConnectionState.DISCONNECTED.code))
    }

    private fun disposeSubscriptions() {
        connectionDisposable?.dispose()
        connectDeviceSubject.onComplete()
        connectionStatusUpdates.dispose()
    }

    private fun establishConnection(rxBleDevice: RxBleDevice): Disposable {
        val deviceId = rxBleDevice.macAddress

        val shouldNotTimeout = connectionTimeout.value <= 0L
        connectionQueue.addToQueue(deviceId)
        updateListeners(ConnectionUpdateSuccess(deviceId, ConnectionState.CONNECTING.code))

        return waitUntilFirstOfQueue(deviceId)
            .switchMap { queue ->
                if (!queue.contains(deviceId)) {
                    Observable.just(
                        EstablishConnectionFailure(
                            deviceId,
                            "Device is not in queue"
                        )
                    )
                } else {
                    connectDevice(rxBleDevice, shouldNotTimeout)
                        .map<EstablishConnectionResult> {
                            EstablishedConnection(
                                rxBleDevice.macAddress,
                                it
                            )
                        }
                }
            }
            .onErrorReturn { error ->
                EstablishConnectionFailure(
                    rxBleDevice.macAddress,
                    error.message ?: "Unknown error"
                )
            }
            .doOnNext {
                // Trigger side effect by calling the lazy initialization of this property so
                // listening to changes starts.
                connectionStatusUpdates
                timestampEstablishConnection = System.currentTimeMillis()
                connectionQueue.removeFromQueue(deviceId)
                if (it is EstablishConnectionFailure) {
                    updateListeners.invoke(ConnectionUpdateError(deviceId, it.errorMessage))
                }
            }
            .doOnError {
                connectionQueue.removeFromQueue(deviceId)
                updateListeners.invoke(
                    ConnectionUpdateError(
                        deviceId, it.message
                            ?: "Unknown error"
                    )
                )
            }
            .subscribe({ connectDeviceSubject.onNext(it) },
                { throwable -> connectDeviceSubject.onError(throwable) })
    }

    private fun connectDevice(
        rxBleDevice: RxBleDevice,
        shouldNotTimeout: Boolean
    ): Observable<RxBleConnection> {
        return connectDeviceGatt(rxBleDevice)
            .compose {
                if (shouldNotTimeout) {
                    it
                } else {
                    it.timeout(
                        Observable.timer(connectionTimeout.value, connectionTimeout.unit)
                    ) {
                        Observable.never<Unit>()
                    }
                }
            }
    }

    private fun connectDeviceGatt(
        rxBleDevice: RxBleDevice,
    ): Observable<RxBleConnection> {
        return Observable.create<Unit> { emitter ->
            with(rxBleDevice.bluetoothDevice) {
                connectGatt(context, autoConnect, object : BluetoothGattCallback() {
                    @SuppressLint("MissingPermission", "NewApi")
                    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                        val deviceAddress = gatt.device.address
                        if (status != BluetoothGatt.GATT_SUCCESS) {
                            Log.w(
                                "BluetoothGattCallback",
                                "Error $status encountered for $deviceAddress! Disconnecting..."
                            )
                            gatt.close()
//                            emitter.onError(Exception())
                        }
                        if (newState != BluetoothProfile.STATE_CONNECTED) {
                            Log.w("BluetoothGattCallback", "Successfully disconnected from $deviceAddress")
                            gatt.close()
//                            emitter.onError(Exception())
                        }
                        emitter.onNext(Unit)
                        emitter.onComplete()
//                        if (bondState == BluetoothDevice.BOND_BONDED) {
//                            Log.w("BluetoothGattCallback", "Successfully connected to $deviceAddress")
//                            emitter.onNext(Unit)
//                        }
//                        createBond()
//                        Observable.interval(5, TimeUnit.SECONDS)
//                            .take(3)
//                            .subscribe {
//                                Log.w("BluetoothGattCallback", "onConnectionStateChange: $it", )
//                                if (bondState == BluetoothDevice.BOND_BONDED) {
//                                    Log.w("BluetoothGattCallback", "Successfully bonded to $deviceAddress")
//                                    emitter.onNext(Unit)
//                                }
//                                if (bondState != BluetoothDevice.BOND_BONDED && it == 2L) {
//                                    emitter.onError(Exception())
//                                }
//                            }
                    }
                })
            }
        }.concatMap {
                Log.w("BluetoothGattCallback", "getConnObservable: bleDevice.establishConnection(false)")
                rxBleDevice.establishConnection(false)
            }
    }

    internal fun clearGattCache(): Completable = currentConnection?.let { connection ->
        when (connection) {
            is EstablishedConnection -> clearGattCache(connection.rxConnection)
            is EstablishConnectionFailure -> Completable.error(Throwable(connection.errorMessage))
        }
    } ?: Completable.error(IllegalStateException("Connection is not established"))

    /**
     * Clear GATT attribute cache using an undocumented method `BluetoothGatt.refresh()`.
     *
     * May trigger the following warning in the system message log:
     *
     * https://android.googlesource.com/platform/frameworks/base/+/pie-release/config/hiddenapi-light-greylist.txt
     *
     *     Accessing hidden method Landroid/bluetooth/BluetoothGatt;->refresh()Z (light greylist, reflection)
     *
     * Known to work up to Android Q beta 2.
     */
    private fun clearGattCache(connection: RxBleConnection): Completable {
        val operation = RxBleCustomOperation { bluetoothGatt, _, _ ->
            try {
                val refreshMethod = bluetoothGatt.javaClass.getMethod("refresh")
                val success = refreshMethod.invoke(bluetoothGatt) as Boolean
                if (success) {
                    Observable.empty<Unit>()
                        .delay(
                            delayMsAfterClearingCache,
                            TimeUnit.MILLISECONDS
                        )
                } else {
                    val reason = "BluetoothGatt.refresh() returned false"
                    Observable.error(RuntimeException(reason))
                }
            } catch (e: ReflectiveOperationException) {
                Observable.error(e)
            }
        }
        return connection.queue(operation).ignoreElements()
    }

    private fun waitUntilFirstOfQueue(deviceId: String) =
        connectionQueue.observeQueue()
            .filter { queue ->
                queue.firstOrNull() == deviceId || !queue.contains(deviceId)
            }
            .takeUntil { it.isEmpty() || it.first() == deviceId }
}
