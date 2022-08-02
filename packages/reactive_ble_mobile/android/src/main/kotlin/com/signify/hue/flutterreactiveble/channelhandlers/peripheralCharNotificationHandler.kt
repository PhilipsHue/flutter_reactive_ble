package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.converters.UuidConverter
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable

class PeripheralCharNotificationHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) :
    EventChannel.StreamHandler {
    private val uuidConverter = UuidConverter()
    private val protobufConverter = ProtobufMessageConverter()

    companion object {
        private var peripheralCharNotificationSink: EventChannel.EventSink? = null
    }

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            peripheralCharNotificationSink = eventSink
        }
    }

    override fun onCancel(objectSink: Any?) {
        peripheralCharNotificationSink = null
    }

    fun addReceivedWriteToStream(charInfo: pb.CharacteristicValueInfo) {
        handleNotificationValue(charInfo.characteristic, charInfo.value.toByteArray())
    }

    private fun handleNotificationValue(
        subscriptionRequest: pb.CharacteristicAddress,
        value: ByteArray
    ) {
        val convertedMsg = protobufConverter.convertCharacteristicInfo(subscriptionRequest, value)
        peripheralCharNotificationSink?.success(convertedMsg.toByteArray())
    }
}
