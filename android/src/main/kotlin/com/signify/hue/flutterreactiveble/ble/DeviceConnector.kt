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
import timber.log.Timber
import java.util.concurrent.TimeUnit

internal class DeviceConnector(
    private val device: RxBleDevice,
    private val connectionTimeout: Duration,
    private val updateListeners: (update: com.signify.hue.flutterreactiveble.ble.ConnectionUpdate) -> Unit,
    private val connectionQueue: com.signify.hue.flutterreactiveble.ble.ConnectionQueue
) {

    companion object {
        private const val minTimeMsBeforeDisconnectingIsAllowed = 200L
        private const val delayMsAfterClearingCache = 300L
    }

    private val connectDeviceSubject = BehaviorSubject.create<com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult>()

    private var timestampEstablishConnection: Long = 0

    @VisibleForTesting
    internal var connectionDisposable: Disposable? = null

    private val lazyConnection = lazy {
        connectionDisposable = establishConnection(device)
        connectDeviceSubject
    }

    private val currentConnection: com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult?
        get() = if (lazyConnection.isInitialized()) connection.value else null

    internal val connection by lazyConnection

    private val connectionStatusUpdates by lazy {
        device.observeConnectionStateChanges()
                .startWith(device.connectionState)
                .map<com.signify.hue.flutterreactiveble.ble.ConnectionUpdate> { com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess(device.macAddress, it.toConnectionState().code) }
                .onErrorReturn {
                    com.signify.hue.flutterreactiveble.ble.ConnectionUpdateError(device.macAddress, it.message
                            ?: "Unknown error")
                }
                .subscribe(
                        {
                            updateListeners.invoke(it)
                        },
                        {
                            Timber.e("Error when initializing connectionstatusupdate for device ${device.macAddress}")
                        }
                )
    }

    internal fun disconnectDevice() {
        val diff = System.currentTimeMillis() - timestampEstablishConnection

        /*
        in order to prevent Android from ignoring disconnects we add a delay when we try to
        disconnect to quickly after establishing connection. https://issuetracker.google.com/issues/37121223
         */
        if (diff < com.signify.hue.flutterreactiveble.ble.DeviceConnector.Companion.minTimeMsBeforeDisconnectingIsAllowed) {
            Single.timer(com.signify.hue.flutterreactiveble.ble.DeviceConnector.Companion.minTimeMsBeforeDisconnectingIsAllowed - diff, TimeUnit.MILLISECONDS)
                    .doFinally {
                        disposeSubscriptions()
                    }.subscribe()
        } else {
            disposeSubscriptions()
        }
    }

    private fun disposeSubscriptions() {
        connectionDisposable?.dispose()
        connectDeviceSubject.onComplete()
        connectionStatusUpdates.dispose()
    }

    private fun establishConnection(rxBleDevice: RxBleDevice): Disposable {
        val deviceId = rxBleDevice.macAddress
        Timber.d("Connecting device $deviceId")

        val shouldNotTimeout = connectionTimeout.value <= 0L
        connectionQueue.addToQueue(deviceId)
        updateListeners(com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess(deviceId, ConnectionState.CONNECTING.code))

        return waitUntilFirstOfQueue(deviceId)
                .switchMap { queue ->
                    if (!queue.contains(deviceId)) {
                        Observable.just(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure(deviceId,
                                "Device is not in queue"))
                    } else {
                        connectDevice(rxBleDevice, shouldNotTimeout)
                                .map<com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult> { com.signify.hue.flutterreactiveble.ble.EstablishedConnection(rxBleDevice.macAddress, it) }
                    }
                }
                .onErrorReturn { error ->
                    com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure(rxBleDevice.macAddress,
                            error.message ?: "Unknown error")
                }
                .doOnNext {
                    Timber.d("Connection established for device ${rxBleDevice.macAddress}")
                    // Trigger side effect by calling the lazy initialization of this property so
                    // listening to changes starts.
                    connectionStatusUpdates
                    timestampEstablishConnection = System.currentTimeMillis()
                    connectionQueue.removeFromQueue(deviceId)
                    if (it is com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure) {
                        updateListeners.invoke(com.signify.hue.flutterreactiveble.ble.ConnectionUpdateError(deviceId, it.errorMessage))
                    }
                }
                .doOnError {
                    connectionQueue.removeFromQueue(deviceId)
                    updateListeners.invoke(com.signify.hue.flutterreactiveble.ble.ConnectionUpdateError(deviceId, it.message
                            ?: "Unknown error"))
                }
                .doOnDispose {
                    Timber.d("Close connection for device ${rxBleDevice.macAddress}")
                }
                .subscribe({ connectDeviceSubject.onNext(it) }, { error ->
                    Timber.d("Connection error for device ${rxBleDevice.macAddress}: ${error.message}")
                })
    }

    private fun connectDevice(rxBleDevice: RxBleDevice, shouldNotTimeout: Boolean): Observable<RxBleConnection> =
            rxBleDevice.establishConnection(shouldNotTimeout)
                    .compose {
                        if (shouldNotTimeout) {
                            it
                        } else {
                            it.timeout(
                                    Observable.timer(connectionTimeout.value, connectionTimeout.unit)
                                            .doOnNext {
                                                Timber.d("Connection timed out for device ${rxBleDevice.macAddress}")
                                            },
                                    Function<RxBleConnection, Observable<Unit>> {
                                        Observable.never<Unit>()
                                    }
                            )
                        }
                    }

    internal fun clearGattCache(): Completable = currentConnection?.let { connection ->
        when (connection) {
            is com.signify.hue.flutterreactiveble.ble.EstablishedConnection -> clearGattCache(connection.rxConnection)
            is com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure -> Completable.error(Throwable(connection.errorMessage))
        }
    } ?: Completable.error(IllegalStateException("Connection is not established"))

    /**
     * Clear GATT attribute cache using an undocumented method `BluetoothGatt.refresh()`.
     *
     * May trigger the following warning in the system message log:
     *
     *     Accessing hidden method Landroid/bluetooth/BluetoothGatt;->refresh()Z (light greylist, reflection)
     *
     * Known to work up to Android Q beta 2.
     */
    private fun clearGattCache(connection: RxBleConnection): Completable {
        val operation = RxBleCustomOperation<Unit> { bluetoothGatt, _, _ ->
            try {
                Timber.d("Clearing GATT cache")
                val refreshMethod = bluetoothGatt.javaClass.getMethod("refresh")
                val success = refreshMethod.invoke(bluetoothGatt) as Boolean
                if (success) {
                    Observable.empty<Unit>()
                            .delay(com.signify.hue.flutterreactiveble.ble.DeviceConnector.Companion.delayMsAfterClearingCache, TimeUnit.MILLISECONDS)
                            .doOnComplete { Timber.d("Clearing GATT cache completed") }
                } else {
                    val reason = "BluetoothGatt.refresh() returned false"
                    Timber.d("Clearing GATT cache failed, $reason")
                    Observable.error(RuntimeException(reason))
                }
            } catch (e: ReflectiveOperationException) {
                Timber.d("Clearing GATT cache failed with exception $e")
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
