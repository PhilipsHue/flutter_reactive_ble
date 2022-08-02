package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import android.util.Log

private const val tag : String = "CentralConnectionHandler"

class CentralConnectionHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) : EventChannel.StreamHandler {
    private var connectCentralSink: EventChannel.EventSink? = null
    private val converter = ProtobufMessageConverter()

    private lateinit var connectionCentralDisposable: Disposable

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            Log.i(tag, "onListen")
            connectCentralSink = eventSink
            connectionCentralDisposable = listenToConnectionCentralChanges()
        }
    }

    override fun onCancel(objectSink: Any?) {
        Log.i(tag, "onCancel")
        connectionCentralDisposable.dispose()
    }

    /*
    fun connectionCentralChanged(update : com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess)
    {
        handleCentralConnectionUpdateResult(converter.convertToDeviceInfo(update))
    }
    */


    private fun listenToConnectionCentralChanges() = bleClient.centralConnectionUpdateSubject
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe { update ->
            when (update) {
                is com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess -> {
                    Log.i(tag, "subscribe")
                    handleCentralConnectionUpdateResult(converter.convertToDeviceInfo(update))
                }
            }
        }

    private fun handleCentralConnectionUpdateResult(connectionUpdateMessage: pb.DeviceInfo) {
        Log.i(tag, "handleCentralConnectionUpdateResult")
        connectCentralSink?.success(connectionUpdateMessage.toByteArray())
    }
}
