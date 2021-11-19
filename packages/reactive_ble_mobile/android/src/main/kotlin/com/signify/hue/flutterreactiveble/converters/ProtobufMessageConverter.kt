package com.signify.hue.flutterreactiveble.converters

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import com.google.protobuf.ByteString
import com.polidea.rxandroidble2.RxBleDeviceServices
import com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess
import com.signify.hue.flutterreactiveble.ble.MtuNegotiateFailed
import com.signify.hue.flutterreactiveble.ble.MtuNegotiateResult
import com.signify.hue.flutterreactiveble.ble.MtuNegotiateSuccesful
import com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityFailed
import com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityResult
import com.signify.hue.flutterreactiveble.ble.RequestConnectionPrioritySuccess
import com.signify.hue.flutterreactiveble.ble.ScanInfo
import com.signify.hue.flutterreactiveble.model.CharacteristicErrorType
import com.signify.hue.flutterreactiveble.model.ClearGattCacheErrorType
import com.signify.hue.flutterreactiveble.model.ConnectionErrorType
import com.signify.hue.flutterreactiveble.model.ConnectionState
import com.signify.hue.flutterreactiveble.model.NegotiateMtuErrorType
import com.signify.hue.flutterreactiveble.model.ScanErrorType
import java.util.UUID
import com.signify.hue.flutterreactiveble.ProtobufModel as pb

@Suppress("TooManyFunctions")
class ProtobufMessageConverter {

    companion object {
        private const val positionMostSignificantBit = 2
        private const val positionLeastSignificantBit = 3
    }

    private val uuidConverter = UuidConverter()

    fun convertScanInfo(scanInfo: ScanInfo): pb.DeviceScanInfo =
            pb.DeviceScanInfo.newBuilder()
                    .setId(scanInfo.deviceId)
                    .setName(scanInfo.name)
                    .setRssi(scanInfo.rssi)
                    .addAllServiceData(createServiceDataEntry(scanInfo.serviceData))
                    .addAllServiceUuids(createServiceUuids(scanInfo.serviceUuids))
                    .setManufacturerData(ByteString.copyFrom(scanInfo.manufacturerData))
                    .build()

    fun convertScanErrorInfo(errorMessage: String?): pb.DeviceScanInfo =
            pb.DeviceScanInfo.newBuilder()
                    .setFailure(pb.GenericFailure.newBuilder()
                            .setCode(ScanErrorType.UNKNOWN.code)
                            .setMessage(errorMessage ?: "")
                            .build())
                    .build()

    fun convertToDeviceInfo(connection: ConnectionUpdateSuccess): pb.DeviceInfo =
            pb.DeviceInfo.newBuilder()
                    .setId(connection.deviceId)
                    .setConnectionState(connection.connectionState)
                    .build()

    fun convertConnectionErrorToDeviceInfo(
            deviceId: String,
            errorMessage: String?
    ): pb.DeviceInfo {

        return pb.DeviceInfo.newBuilder()
                .setId(deviceId)
                .setConnectionState(ConnectionState.DISCONNECTED.code)
                .setFailure(pb.GenericFailure.newBuilder()
                        .setCode(ConnectionErrorType.FAILEDTOCONNECT.code)
                        .setMessage(errorMessage ?: "")
                        .build())
                .build()
    }

    fun convertClearGattCacheError(code: ClearGattCacheErrorType, message: String?): pb.ClearGattCacheInfo {
        val failure = pb.GenericFailure.newBuilder().setCode(code.code)
        message?.let(failure::setMessage)
        return pb.ClearGattCacheInfo.newBuilder().setFailure(failure).build()
    }

    fun convertCharacteristicInfo(
            request: pb.CharacteristicAddress,
            value: ByteArray
    ): pb.CharacteristicValueInfo {

        val characteristicAddress = createCharacteristicAddress(request)

        return pb.CharacteristicValueInfo.newBuilder()
                .setCharacteristic(characteristicAddress)
                .setValue(ByteString.copyFrom(value))
                .build()
    }

    fun convertCharacteristicError(
            request: pb.CharacteristicAddress,
            error: String?
    ): pb.CharacteristicValueInfo {
        val characteristicAdress = createCharacteristicAddress(request)
        val failure = pb.GenericFailure.newBuilder()
                .setCode(CharacteristicErrorType.UNKNOWN.code)
                .setMessage(error ?: "Unknown error")

        return pb.CharacteristicValueInfo.newBuilder()
                .setCharacteristic(characteristicAdress)
                .setFailure(failure)
                .build()
    }

    fun convertWriteCharacteristicInfo(
            request: pb.WriteCharacteristicRequest,
            error: String?
    ): pb.WriteCharacteristicInfo {
        val builder = pb.WriteCharacteristicInfo.newBuilder()
                .setCharacteristic(request.characteristic)

        error?.let {
            val failure = pb.GenericFailure.newBuilder()
                    .setCode(CharacteristicErrorType.UNKNOWN.code)
                    .setMessage(error)

            builder.setFailure(failure)
        }

        return builder.build()
    }

    fun convertNegotiateMtuInfo(result: MtuNegotiateResult): pb.NegotiateMtuInfo =
            when (result) {
                is MtuNegotiateSuccesful -> pb.NegotiateMtuInfo.newBuilder()
                        .setDeviceId(result.deviceId)
                        .setMtuSize(result.size)
                        .build()
                is MtuNegotiateFailed -> {

                    val failure = pb.GenericFailure.newBuilder()
                            .setCode(NegotiateMtuErrorType.UNKNOWN.code)
                            .setMessage(result.errorMessage)
                            .build()

                    pb.NegotiateMtuInfo.newBuilder()
                            .setDeviceId(result.deviceId)
                            .setFailure(failure)
                            .build()
                }
            }

    fun convertRequestConnectionPriorityInfo(
            result: RequestConnectionPriorityResult
    ): pb.ChangeConnectionPriorityInfo {
        return when (result) {
            is RequestConnectionPrioritySuccess -> pb.ChangeConnectionPriorityInfo.newBuilder()
                    .setDeviceId(result.deviceId)
                    .build()
            is RequestConnectionPriorityFailed -> {
                val failure = pb.GenericFailure.newBuilder()
                        .setCode(0)
                        .setMessage(result.errorMessage)
                        .build()

                pb.ChangeConnectionPriorityInfo.newBuilder()
                        .setDeviceId(result.deviceId)
                        .setFailure(failure)
                        .build()
            }
        }
    }

    fun convertDiscoverServicesInfo(
            deviceId: String,
            services: RxBleDeviceServices
    ): pb.DiscoverServicesInfo {
        return pb.DiscoverServicesInfo.newBuilder()
                .setDeviceId(deviceId)
                .addAllServices(services.bluetoothGattServices.map { fromBluetoothGattService(it) })
                .build()
    }

    private fun fromBluetoothGattService(gattService: BluetoothGattService): pb.DiscoveredService {
        return pb.DiscoveredService.newBuilder()
                .setServiceUuid(createUuidFromParcelUuid(gattService.uuid))
                .addAllCharacteristicUuids(gattService.characteristics.map { createUuidFromParcelUuid(it.uuid) })
                .addAllCharacteristics(gattService.characteristics.map {
                    val prop = it.properties
                    val readable = (prop and BluetoothGattCharacteristic.PROPERTY_READ) > 0
                    val write = (prop and BluetoothGattCharacteristic.PROPERTY_WRITE) > 0
                    val writeNoResp = (prop and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE) > 0
                    val notify = (prop and BluetoothGattCharacteristic.PROPERTY_NOTIFY) > 0
                    val indicate = (prop and BluetoothGattCharacteristic.PROPERTY_INDICATE) > 0

                    pb.DiscoveredCharacteristic.newBuilder()
                            .setCharacteristicId(createUuidFromParcelUuid(it.uuid))
                            .setServiceId(createUuidFromParcelUuid(it.service.uuid))
                            .setIsReadable(readable)
                            .setIsWritableWithResponse(write)
                            .setIsWritableWithoutResponse(writeNoResp)
                            .setIsNotifiable(notify)
                            .setIsIndicatable(indicate)
                            .build()
                })
                .addAllIncludedServices(gattService.includedServices.map { convertInternalService(it) })
                .build()
    }

    private fun convertInternalService(gattService: BluetoothGattService): pb.DiscoveredService {
        val root = pb.DiscoveredService.newBuilder()
                .setServiceUuid(createUuidFromParcelUuid(gattService.uuid))
                .addAllCharacteristicUuids(gattService.characteristics.map { createUuidFromParcelUuid(it.uuid) })

        val children = gattService.includedServices.map {
            convertInternalService(it)
        }
        return root.addAllIncludedServices(children).build()
    }

    private fun createCharacteristicAddress(request: pb.CharacteristicAddress):
            pb.CharacteristicAddress.Builder? {
        return pb.CharacteristicAddress.newBuilder()
                .setDeviceId(request.deviceId)
                .setServiceUuid(request.serviceUuid)
                .setCharacteristicUuid(request.characteristicUuid)
    }

    private fun createServiceDataEntry(serviceData: Map<UUID, ByteArray>): List<pb.ServiceDataEntry> {

        val serviceDataEntries = mutableListOf<pb.ServiceDataEntry>()

        // Needed ugly for-loop because we support API23 that does not support kotlin foreach
        for (entry: Map.Entry<UUID, ByteArray> in serviceData) {
            serviceDataEntries.add(pb.ServiceDataEntry.newBuilder()
                    .setServiceUuid(createUuidFromParcelUuid(entry.key))
                    .setData(ByteString.copyFrom(entry.value))
                    .build())
        }

        return serviceDataEntries
    }

    private fun createServiceUuids(serviceUuids: List<UUID>): List<pb.Uuid> {
        return serviceUuids.map { createUuidFromParcelUuid(it) }
    }

    private fun createUuidFromParcelUuid(uuid: UUID): pb.Uuid {
        val convertedUuid = uuidConverter.byteArrayFromUuid(uuid)

        return pb.Uuid.newBuilder().setData(ByteString.copyFrom(convertedUuid)).build()
    }
}
