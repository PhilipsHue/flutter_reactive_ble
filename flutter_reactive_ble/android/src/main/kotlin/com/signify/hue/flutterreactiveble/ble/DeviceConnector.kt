package com.signify.hue.flutterreactiveble.ble

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
import io.reactivex.functions.Function
import io.reactivex.subjects.BehaviorSubject
import java.util.concurrent.TimeUnit

internal class DeviceConnector(
        private val device: RxBleDevice,
        private val connectionTimeout: Duration,
        private val updateListeners: (update: ConnectionUpdate) -> Unit,
        private val connectionQueue: ConnectionQueue
) {

    companion object {
        private const val minTimeMsBeforeDisconnectingIsAllowed = 200L
        private const val delayMsAfterClearingCache = 300L
    }

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
                .map<ConnectionUpdate> { ConnectionUpdateSuccess(device.macAddress, it.toConnectionState().code) }
                .onErrorReturn {
                    ConnectionUpdateError(device.macAddress, it.message
                            ?: "Unknown error")
                }
                .subscribe {
                    updateListeners.invoke(it)
                }
    }

    internal fun disconnectDevice(deviceId: String) {
        val diff = System.currentTimeMillis() - timestampEstablishConnection

        /*
        in order to prevent Android from ignoring disconnects we add a delay when we try to
        disconnect to quickly after establishing connection. https://issuetracker.google.com/issues/37121223
         */
        if (diff < DeviceConnector.Companion.minTimeMsBeforeDisconnectingIsAllowed) {
            Single.timer(DeviceConnector.Companion.minTimeMsBeforeDisconnectingIsAllowed - diff, TimeUnit.MILLISECONDS)
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
                        Observable.just(EstablishConnectionFailure(deviceId,
                                "Device is not in queue"))
                    } else {
                        connectDevice(rxBleDevice, shouldNotTimeout)
                                .map<EstablishConnectionResult> { EstablishedConnection(rxBleDevice.macAddress, it) }
                    }
                }
                .onErrorReturn { error ->
                    EstablishConnectionFailure(rxBleDevice.macAddress,
                            error.message ?: "Unknown error")
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
                    updateListeners.invoke(ConnectionUpdateError(deviceId, it.message
                            ?: "Unknown error"))
                }
                .subscribe({ connectDeviceSubject.onNext(it) },
                        { throwable -> connectDeviceSubject.onError(throwable) })
    }

    private fun connectDevice(rxBleDevice: RxBleDevice, shouldNotTimeout: Boolean): Observable<RxBleConnection> =
            rxBleDevice.establishConnection(shouldNotTimeout)
                    .compose {
                        if (shouldNotTimeout) {
                            it
                        } else {
                            it.timeout(
                                    Observable.timer(connectionTimeout.value, connectionTimeout.unit),
                                    Function<RxBleConnection, Observable<Unit>> {
                                        Observable.never<Unit>()
                                    }
                            )
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
        val operation = RxBleCustomOperation<Unit> { bluetoothGatt, _, _ ->
            try {
                val refreshMethod = bluetoothGatt.javaClass.getMethod("refresh")
                val success = refreshMethod.invoke(bluetoothGatt) as Boolean
                if (success) {
                    Observable.empty<Unit>()
                            .delay(DeviceConnector.Companion.delayMsAfterClearingCache, TimeUnit.MILLISECONDS)
                } else {
                    val reason = "BluetoothGatt.refresh() returned false"
                    Observable.error(RuntimeException(reason))
                }
            } catch (e: ReflectiveOperationException) {
                Observable.error<Unit>(e)
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
