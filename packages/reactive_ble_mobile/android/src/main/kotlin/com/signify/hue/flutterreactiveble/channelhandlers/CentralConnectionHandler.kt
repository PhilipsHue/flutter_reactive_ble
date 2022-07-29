package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.utils.Duration
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import java.util.concurrent.TimeUnit

class CentralConnectionHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) : EventChannel.StreamHandler {
    private var connectCentralSink: EventChannel.EventSink? = null
    private val converter = ProtobufMessageConverter()

    private lateinit var connectionCentralDisposable: Disposable

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            connectCentralSink = eventSink
            connectionCentralDisposable = listenToConnectionCentralChanges()
        }
    }

    override fun onCancel(objectSink: Any?) {
        connectionCentralDisposable.dispose()
    }

    private fun listenToConnectionCentralChanges() = bleClient.connectionUpdateSubject
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe { update ->
            when (update) {
                is com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess -> {
                    handleCentralConnectionUpdateResult(converter.convertToDeviceInfo(update))
                }
                is com.signify.hue.flutterreactiveble.ble.ConnectionUpdateError -> {
                    handleCentralConnectionUpdateResult(
                        converter.convertConnectionErrorToDeviceInfo(update.deviceId, update.errorMessage)
                    )
                }
            }
        }

    private fun handleCentralConnectionUpdateResult(connectionUpdateMessage: pb.DeviceInfo) {
        connectCentralSink?.success(connectionUpdateMessage.toByteArray())
    }
}
