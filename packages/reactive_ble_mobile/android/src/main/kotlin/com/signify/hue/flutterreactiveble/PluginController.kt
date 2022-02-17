package com.signify.hue.flutterreactiveble

import android.content.Context
import com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityFailed
import com.signify.hue.flutterreactiveble.channelhandlers.BleStatusHandler
import com.signify.hue.flutterreactiveble.channelhandlers.CharNotificationHandler
import com.signify.hue.flutterreactiveble.channelhandlers.DeviceConnectionHandler
import com.signify.hue.flutterreactiveble.channelhandlers.ScanDevicesHandler
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.converters.UuidConverter
import com.signify.hue.flutterreactiveble.model.ClearGattCacheErrorType
import com.signify.hue.flutterreactiveble.utils.discard
import com.signify.hue.flutterreactiveble.utils.toConnectionPriority
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import java.util.UUID
import com.signify.hue.flutterreactiveble.ProtobufModel as pb

@Suppress("TooManyFunctions")
class PluginController {
    private val pluginMethods = mapOf<String, (call: MethodCall, result: Result) -> Unit>(
            "initialize" to this::initializeClient,
            "deinitialize" to this::deinitializeClient,
            "scanForDevices" to this::scanForDevices,
            "connectToDevice" to this::connectToDevice,
            "clearGattCache" to this::clearGattCache,
            "disconnectFromDevice" to this::disconnectFromDevice,
            "readCharacteristic" to this::readCharacteristic,
            "writeCharacteristicWithResponse" to this::writeCharacteristicWithResponse,
            "writeCharacteristicWithoutResponse" to this::writeCharacteristicWithoutResponse,
            "readNotifications" to this::readNotifications,
            "stopNotifications" to this::stopNotifications,
            "negotiateMtuSize" to this::negotiateMtuSize,
            "requestConnectionPriority" to this::requestConnectionPriority,
            "discoverServices" to this::discoverServices
    )

    lateinit var bleClient: com.signify.hue.flutterreactiveble.ble.BleClient

    lateinit var scanchannel: EventChannel
    lateinit var deviceConnectionChannel: EventChannel
    lateinit var charNotificationChannel: EventChannel

    lateinit var scandevicesHandler: ScanDevicesHandler
    lateinit var deviceConnectionHandler: DeviceConnectionHandler
    lateinit var charNotificationHandler: CharNotificationHandler

    private val uuidConverter = UuidConverter()
    private val protoConverter = ProtobufMessageConverter()

    internal fun initialize(messenger: BinaryMessenger, context: Context) {
        bleClient = com.signify.hue.flutterreactiveble.ble.ReactiveBleClient(context)

        scanchannel = EventChannel(messenger, "flutter_reactive_ble_scan")
        deviceConnectionChannel = EventChannel(messenger, "flutter_reactive_ble_connected_device")
        charNotificationChannel = EventChannel(messenger, "flutter_reactive_ble_char_update")
        val bleStatusChannel = EventChannel(messenger, "flutter_reactive_ble_status")

        scandevicesHandler = ScanDevicesHandler(bleClient)
        deviceConnectionHandler = DeviceConnectionHandler(bleClient)
        charNotificationHandler = CharNotificationHandler(bleClient)
        val bleStatusHandler = BleStatusHandler(bleClient)

        scanchannel.setStreamHandler(scandevicesHandler)
        deviceConnectionChannel.setStreamHandler(deviceConnectionHandler)
        charNotificationChannel.setStreamHandler(charNotificationHandler)
        bleStatusChannel.setStreamHandler(bleStatusHandler)
    }

    internal fun deinitialize() {
        scandevicesHandler.stopDeviceScan()
        deviceConnectionHandler.disconnectAll()
    }

    internal fun execute(call: MethodCall, result: Result) {
        pluginMethods[call.method]?.invoke(call, result) ?: result.notImplemented()
    }

    private fun initializeClient(call: MethodCall, result: Result) {
        bleClient.initializeClient()
        result.success(null)
    }

    private fun deinitializeClient(call: MethodCall, result: Result) {
        deinitialize()
        result.success(null)
    }

    private fun scanForDevices(call: MethodCall, result: Result) {
        scandevicesHandler.prepareScan(pb.ScanForDevicesRequest.parseFrom(call.arguments as ByteArray))
        result.success(null)
    }

    private fun connectToDevice(call: MethodCall, result: Result) {
        result.success(null)
        val connectDeviceMessage = pb.ConnectToDeviceRequest.parseFrom(call.arguments as ByteArray)
        deviceConnectionHandler.connectToDevice(connectDeviceMessage)
    }

    private fun clearGattCache(call: MethodCall, result: Result) {
        val args = pb.ClearGattCacheRequest.parseFrom(call.arguments as ByteArray)
        bleClient.clearGattCache(args.deviceId)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        {
                            val info = pb.ClearGattCacheInfo.getDefaultInstance()
                            result.success(info.toByteArray())
                        },
                        {
                            val info = protoConverter.convertClearGattCacheError(
                                    ClearGattCacheErrorType.UNKNOWN,
                                    it.message
                            )
                            result.success(info.toByteArray())
                        }
                )
                .discard()
    }

    private fun disconnectFromDevice(call: MethodCall, result: Result) {
        result.success(null)
        val connectDeviceMessage = pb.DisconnectFromDeviceRequest.parseFrom(call.arguments as ByteArray)
        deviceConnectionHandler.disconnectDevice(connectDeviceMessage.deviceId)
    }

    private fun readCharacteristic(call: MethodCall, result: Result) {
        result.success(null)

        val readCharMessage = pb.ReadCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        val deviceId = readCharMessage.characteristic.deviceId
        val characteristic = uuidConverter.uuidFromByteArray(readCharMessage.characteristic.characteristicUuid.data.toByteArray())

        bleClient.readCharacteristic(
                readCharMessage.characteristic.deviceId, characteristic
        )
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        { charResult ->
                            when (charResult) {
                                is com.signify.hue.flutterreactiveble.ble.CharOperationSuccessful -> {
                                    val charInfo = protoConverter.convertCharacteristicInfo(
                                            readCharMessage.characteristic,
                                            charResult.value.toByteArray()
                                    )
                                    charNotificationHandler.addSingleReadToStream(charInfo)
                                }
                                is com.signify.hue.flutterreactiveble.ble.CharOperationFailed -> {
                                    protoConverter.convertCharacteristicError(readCharMessage.characteristic,
                                            "Failed to connect")
                                    charNotificationHandler.addSingleErrorToStream(
                                            readCharMessage.characteristic,
                                            charResult.errorMessage
                                    )
                                }
                            }
                        },
                        { throwable ->
                            protoConverter.convertCharacteristicError(
                                    readCharMessage.characteristic,
                                    throwable.message)
                            charNotificationHandler.addSingleErrorToStream(
                                    readCharMessage.characteristic,
                                    throwable?.message ?: "Failure")
                        }
                )
                .discard()
    }

    private fun writeCharacteristicWithResponse(call: MethodCall, result: Result) {
        executeWriteAndPropagateResultToChannel(call, result, com.signify.hue.flutterreactiveble.ble.BleClient::writeCharacteristicWithResponse)
    }

    private fun writeCharacteristicWithoutResponse(call: MethodCall, result: Result) {
        executeWriteAndPropagateResultToChannel(call, result, com.signify.hue.flutterreactiveble.ble.BleClient::writeCharacteristicWithoutResponse)
    }

    private fun executeWriteAndPropagateResultToChannel(
            call: MethodCall,
            result: Result,
            writeOperation: com.signify.hue.flutterreactiveble.ble.BleClient.(
                    deviceId: String,
                    characteristic: UUID,
                    value: ByteArray
            ) -> Single<com.signify.hue.flutterreactiveble.ble.CharOperationResult>
    ) {
        val writeCharMessage = pb.WriteCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        bleClient.writeOperation(writeCharMessage.characteristic.deviceId,
                uuidConverter.uuidFromByteArray(writeCharMessage.characteristic.characteristicUuid.data.toByteArray()),
                writeCharMessage.value.toByteArray())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ operationResult ->
                    when (operationResult) {
                        is com.signify.hue.flutterreactiveble.ble.CharOperationSuccessful -> {
                            result.success(protoConverter.convertWriteCharacteristicInfo(writeCharMessage,
                                    null).toByteArray())
                        }
                        is com.signify.hue.flutterreactiveble.ble.CharOperationFailed -> {
                            result.success(protoConverter.convertWriteCharacteristicInfo(writeCharMessage,
                                    operationResult.errorMessage).toByteArray())
                        }
                    }
                },
                        { throwable ->
                            result.success(protoConverter.convertWriteCharacteristicInfo(writeCharMessage,
                                    throwable.message).toByteArray())
                        }
                )
                .discard()
    }

    private fun readNotifications(call: MethodCall, result: Result) {
        val request = pb.NotifyCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        charNotificationHandler.subscribeToNotifications(request)
        result.success(null)
    }

    private fun stopNotifications(call: MethodCall, result: Result) {
        val request = pb.NotifyNoMoreCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        charNotificationHandler.unsubscribeFromNotifications(request)
        result.success(null)
    }

    private fun negotiateMtuSize(call: MethodCall, result: Result) {
        val request = pb.NegotiateMtuRequest.parseFrom(call.arguments as ByteArray)
        bleClient.negotiateMtuSize(request.deviceId, request.mtuSize)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ mtuResult ->
                    result.success(protoConverter.convertNegotiateMtuInfo(mtuResult).toByteArray())
                }, { throwable ->
                    result.success(protoConverter.convertNegotiateMtuInfo(com.signify.hue.flutterreactiveble.ble.MtuNegotiateFailed(request.deviceId,
                            throwable.message ?: "")).toByteArray())
                }
                )
                .discard()
    }

    private fun requestConnectionPriority(call: MethodCall, result: Result) {
        val request = pb.ChangeConnectionPriorityRequest.parseFrom(call.arguments as ByteArray)

        bleClient.requestConnectionPriority(request.deviceId, request.priority.toConnectionPriority())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ requestResult ->
                    result.success(protoConverter
                            .convertRequestConnectionPriorityInfo(requestResult).toByteArray())
                },
                        { throwable ->
                            result.success(protoConverter.convertRequestConnectionPriorityInfo(
                                    RequestConnectionPriorityFailed(request.deviceId, throwable?.message
                                            ?: "Unknown error")).toByteArray())
                        })
                .discard()
    }

    private fun discoverServices(call: MethodCall, result: Result) {
        val request = pb.DiscoverServicesRequest.parseFrom(call.arguments as ByteArray)

        bleClient.discoverServices(request.deviceId)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ discoverResult ->
                    result.success(protoConverter.convertDiscoverServicesInfo(request.deviceId, discoverResult).toByteArray())
                }, {
                    throwable -> result.error("service_discovery_failure", throwable.message, null)
                })
                .discard()
    }
}
