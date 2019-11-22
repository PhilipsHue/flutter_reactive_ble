package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.utils.Duration
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import timber.log.Timber
import java.util.concurrent.TimeUnit

class DeviceConnectionHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) : EventChannel.StreamHandler {
    private var connectDeviceSink: EventChannel.EventSink? = null
    private val converter = ProtobufMessageConverter()

    private lateinit var connectionUpdatesDisposable: Disposable

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            connectDeviceSink = eventSink
            connectionUpdatesDisposable = listenToConnectionChanges()
        }
    }

    override fun onCancel(objectSink: Any?) {
        Timber.d("Connection cancelled")
        disconnectAll()
        connectionUpdatesDisposable.dispose()
    }

    fun connectToDevice(connectToDeviceMessage: pb.ConnectToDeviceRequest) {
        val deviceId = connectToDeviceMessage.deviceId
        Timber.d("Try to connect to device $deviceId")
        bleClient.connectToDevice(
                deviceId,
                Duration(connectToDeviceMessage.timeoutInMs.toLong(), TimeUnit.MILLISECONDS)
        )
    }

    fun disconnectDevice(deviceId: String) {
        bleClient.disconnectDevice(deviceId)
    }

    fun disconnectAll() {
        connectDeviceSink = null
        bleClient.disconnectAllDevices()
    }

    private fun listenToConnectionChanges() = bleClient.connectionUpdateSubject
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe({ update ->
                when (update) {
                    is com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess -> {
                        handleDeviceConnectionUpdateResult(converter.convertToDeviceInfo(update))
                        Timber.d("Update device: ${update.deviceId} status=${update.connectionState}")
                    }
                    is com.signify.hue.flutterreactiveble.ble.ConnectionUpdateError -> {
                        handleDeviceConnectionUpdateResult(
                                converter.convertConnectionErrorToDeviceInfo(update.deviceId, update.errorMessage)
                        )
                        Timber.d("Error conn device:  ${update.deviceId} error=${update.errorMessage}")
                    }
                }
            }, { error ->
                Timber.e("cannot deliver status update event because of: ${error.message}")
            })

    private fun handleDeviceConnectionUpdateResult(connectionUpdateMessage: pb.DeviceInfo) {
        connectDeviceSink?.success(connectionUpdateMessage.toByteArray())
    }
}
