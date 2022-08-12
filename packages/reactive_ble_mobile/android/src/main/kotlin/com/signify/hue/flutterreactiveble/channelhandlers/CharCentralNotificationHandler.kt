package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.converters.UuidConverter
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import android.util.Log
import java.util.UUID

private const val tag : String = "CharCentralNotificationHandler"

class CharCentralNotificationHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) :
    EventChannel.StreamHandler {
    private val uuidConverter = UuidConverter()
    private val protobufConverter = ProtobufMessageConverter()

    private var charCentralNotificationSink: EventChannel.EventSink? = null
    private lateinit var charRequestDisposable: Disposable

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            Log.i(tag, "onListen")
            charCentralNotificationSink = eventSink
            charRequestDisposable = listenToCharRequest()
        }
    }

    override fun onCancel(objectSink: Any?) {
        Log.i(tag, "onCancel")
        charRequestDisposable.dispose()
    }

    /*
    fun connectionCentralChanged(update : com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess)
    {
        handleCentralConnectionUpdateResult(converter.convertToDeviceInfo(update))
    }
    */


    private fun listenToCharRequest() = bleClient.charRequestSubject
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe { charResult ->
            when (charResult) {
                is com.signify.hue.flutterreactiveble.ble.CharOperationSuccessful -> {
                    Log.i(tag, "Write request forworded")
                    handleValue(charResult.deviceId, charResult.value.toByteArray())
                }
            }
        }

    private fun handleValue(
        UuidString: String,
        value: ByteArray
    ) {
        Log.i(tag, "handleValue")

        // var characteristic: QualifiedCharacteristic;
        // var request = pb.ReadCharacteristicRequest();

        /*
        characteristic = QualifiedCharacteristic(
                characteristicId: ParcelUuid.fromString(String),
                serviceId: Uuid.parse(''),
                deviceId: '',
        );
        */
        //request = protobufConverter.createReadCharacteristicRequest(characteristic)
        /*
        val characteristicAddress = pb.CharacteristicAddress.newBuilder()
            .setDeviceId("")
            .setServiceUuid(uuidConverter.byteArrayFromUuid(UUID.fromString(UuidString)))
            .setCharacteristicUuid(uuidConverter.byteArrayFromUuid(UUID.fromString(UuidString)))
        */
        val characteristicAddress = protobufConverter.convertToCharacteristicAddress("", UUID.fromString(UuidString), UUID.fromString(UuidString))
        val convertedMsg = protobufConverter.convertCharacteristicInfo(characteristicAddress, value)
        charCentralNotificationSink?.success(convertedMsg.toByteArray())
    }
    /*
    companion object {
        private var charCentralNotificationSink: EventChannel.EventSink? = null
    }

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            charCentralNotificationSink = eventSink
        }
    }

    override fun onCancel(objectSink: Any?) {
        charCentralNotificationSink = null
    }

    fun addReceivedWriteToStream(charInfo: pb.CharacteristicValueInfo) {
        handleNotificationValue(charInfo.characteristic, charInfo.value.toByteArray())
    }

    private fun handleNotificationValue(
        subscriptionRequest: pb.CharacteristicAddress,
        value: ByteArray
    ) {
        val convertedMsg = protobufConverter.convertCharacteristicInfo(subscriptionRequest, value)
        charCentralNotificationSink?.success(convertedMsg.toByteArray())
    }
    */
}
