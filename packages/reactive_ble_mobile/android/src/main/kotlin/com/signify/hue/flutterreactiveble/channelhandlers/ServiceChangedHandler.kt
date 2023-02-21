package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.converters.UuidConverter
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import android.util.Log
import java.util.UUID

private const val tag : String = "ServiceChangedHandler"

class ServiceChangedHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) :
    EventChannel.StreamHandler {
    private val uuidConverter = UuidConverter()
    private val protobufConverter = ProtobufMessageConverter()

    private var serviceChangedSink: EventChannel.EventSink? = null
    private lateinit var serviceChangedDisposable: Disposable

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            Log.i(tag, "onListen")
            serviceChangedSink = eventSink
            serviceChangedDisposable = listenToServiceChanged()
        }
    }

    override fun onCancel(objectSink: Any?) {
        Log.i(tag, "onCancel")
        serviceChangedDisposable.dispose()
    }

    private fun listenToServiceChanged() = bleClient.serviceChangedSubject
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe { charResult ->
            when (charResult) {
                is com.signify.hue.flutterreactiveble.ble.CharOperationSuccessful -> {
                    Log.i(tag, "received service modified")
                    handleServiceChanged(charResult.deviceId, charResult.value.toByteArray())
                }
            }
        }

    private fun handleServiceChanged(
        UuidString: String,
        value: ByteArray
    ) {
        Log.i(tag, "handleServiceChanged")

        val characteristicAddress = protobufConverter.convertToCharacteristicAddress("", UUID.fromString(UuidString), UUID.fromString(UuidString))
        val convertedMsg = protobufConverter.convertCharacteristicInfo(characteristicAddress, value)
        serviceChangedSink?.success(convertedMsg.toByteArray())
    }
}