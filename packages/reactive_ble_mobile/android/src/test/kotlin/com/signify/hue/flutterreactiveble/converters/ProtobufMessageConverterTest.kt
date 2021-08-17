package com.signify.hue.flutterreactiveble.converters

import com.google.common.truth.Truth.assertThat
import com.google.protobuf.ByteString
import com.signify.hue.flutterreactiveble.ble.ConnectionUpdateSuccess
import com.signify.hue.flutterreactiveble.ble.MtuNegotiateFailed
import com.signify.hue.flutterreactiveble.ble.MtuNegotiateSuccesful
import com.signify.hue.flutterreactiveble.ble.ScanInfo
import com.signify.hue.flutterreactiveble.model.NegotiateMtuErrorType
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import java.util.UUID
import com.signify.hue.flutterreactiveble.ProtobufModel as pb

class ProtobufMessageConverterTest {
    val protobufConverter = ProtobufMessageConverter()

    @Nested
    @DisplayName("Convert to scaninfo")
    inner class ScanInfoTest {

        @Test
        fun `converts scan result to DeviceDiscoveryMessage`() {
            val scanInfo = createScanInfo()

            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result).isInstanceOf(pb.DeviceScanInfo::class.java)
        }

        @Test
        fun `converts macaddress into message id`() {
            val scanInfo = createScanInfo()

            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result.id).isEqualTo(scanInfo.deviceId)
        }

        @Test
        fun `converts name into message name`() {
            val scanInfo = createScanInfo()

            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result.name).isEqualTo(scanInfo.name)
        }

        @Test
        fun `converts rssi into message rssi`() {
            val scanInfo = createScanInfo()
            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result.rssi).isEqualTo(scanInfo.rssi)
        }

        @Test
        fun `converts servicedataentry into message structure`() {
            val scanInfo = createScanInfo()

            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result.serviceDataList.size).isEqualTo(1)
        }

        @Test
        fun `converts serviceuuids into message structure`() {
            val scanInfo = createScanInfo()

            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result.serviceUuidsList.size).isEqualTo(1)
        }

        @Test
        fun `converts servicedataentry value into message structure`() {
            val scanInfo = createScanInfo()
            val expected = ByteString.copyFrom("12".toByteArray())

            val result = protobufConverter.convertScanInfo(scanInfo)

            val value = result.serviceDataList.first().data

            assertThat(value).isEqualTo(expected)
        }

        @Test
        fun `converts manufacturer data into message manufacturer data`() {
            val scanInfo = createScanInfo()

            val result = protobufConverter.convertScanInfo(scanInfo)

            assertThat(result.manufacturerData.toByteArray()).isEqualTo(scanInfo.manufacturerData)
        }
    }

    @Nested
    @DisplayName("Convert to deviceinfo")
    inner class DeviceInfoTest {

        @Test
        fun `converts device id as parameter in device connection message`() {
            val deviceId = "2"
            val connection = ConnectionUpdateSuccess(deviceId, 2)
            assertThat(protobufConverter.convertToDeviceInfo(connection).id).isEqualTo(deviceId)
        }

        @Test
        fun `converts result as parameter in device connection message`() {
            val result = 0
            val connection = ConnectionUpdateSuccess("", result)
            assertThat(protobufConverter.convertToDeviceInfo(connection).connectionState).isEqualTo(result)
        }
    }

    @Nested
    @DisplayName("Convert to charinfo")
    inner class ConvertCharInfoTest {

        @Test
        fun `converts to a characteristicvalueInfo object `() {
            val request = createCharacteristicRequest("a", UUID.randomUUID())

            assertThat(protobufConverter.convertCharacteristicInfo(request.characteristic, byteArrayOf(1)))
                    .isInstanceOf(pb.CharacteristicValueInfo::class.java)
        }

        @Test
        fun `converts a char value and request into a characteristic info value `() {
            val request = createCharacteristicRequest("a", UUID.randomUUID())
            val expectedValue = byteArrayOf(1)
            val valueInfo = protobufConverter.convertCharacteristicInfo(request.characteristic, expectedValue)

            assertThat(valueInfo.value).isEqualTo(ByteString.copyFrom(expectedValue))
        }
    }

    @Nested
    @DisplayName("Convert to negotiatemtuinfo")
    inner class NegotiateMtuInfoTest {

        @Test
        fun `converts to negotiatemtuinfo object`() {
            val result = MtuNegotiateSuccesful("", 3)

            assertThat(protobufConverter.convertNegotiateMtuInfo(result)).isInstanceOf(pb.NegotiateMtuInfo::class.java)
        }

        @Test
        fun `converts deviceId`() {
            val result = MtuNegotiateSuccesful("id", 3)
            assertThat(protobufConverter.convertNegotiateMtuInfo(result).deviceId).isEqualTo(result.deviceId)
        }

        @Test
        fun `converts mtusize`() {
            val result = MtuNegotiateSuccesful("id", 3)
            assertThat(protobufConverter.convertNegotiateMtuInfo(result).mtuSize).isEqualTo(result.size)
        }

        @Test
        fun `sets default value for error in case no error occurred`() {
            val result = MtuNegotiateSuccesful("id", 3)
            assertThat(protobufConverter.convertNegotiateMtuInfo(result).failure.message).isEqualTo("")
        }

        @Test
        fun `converts error message properly`() {
            val errorMessage = "whoops"
            val result = MtuNegotiateFailed("id", errorMessage)
            assertThat(protobufConverter.convertNegotiateMtuInfo(result).failure.message)
                    .isEqualTo(errorMessage)
        }

        @Test
        fun `converts error code`() {
            val result = MtuNegotiateFailed("id", "")
            assertThat(protobufConverter.convertNegotiateMtuInfo(result).failure.code)
                    .isEqualTo(NegotiateMtuErrorType.UNKNOWN.code)
        }
    }

    private fun createScanInfo(): ScanInfo {
        val macAdress = "123"
        val deviceName = "Testdevice"
        val rssi = 200
        val uuid = UUID.randomUUID()
        val testString = "12".toByteArray()
        val serviceUuid = UUID.randomUUID()

        val serviceData = mutableMapOf<UUID, ByteArray>()
        serviceData[uuid] = testString

        val manufacturerData = "123".toByteArray()

        return ScanInfo(
                deviceId = macAdress, name = deviceName,
                rssi = rssi, serviceData = serviceData, manufacturerData = manufacturerData,
                serviceUuids = listOf(serviceUuid),
        )
    }

    private fun createCharacteristicRequest(deviceId: String, serviceUuid: UUID): pb.ReadCharacteristicRequest {
        val uuidConverter = UuidConverter()
        val uuid = pb.Uuid.newBuilder()
                .setData(ByteString.copyFrom(uuidConverter.byteArrayFromUuid(serviceUuid)))

        val characteristicAddress = pb.CharacteristicAddress.newBuilder()
                .setDeviceId(deviceId)
                .setServiceUuid(uuid)
                .setCharacteristicUuid(uuid)

        return pb.ReadCharacteristicRequest.newBuilder()
                .setCharacteristic(characteristicAddress)
                .build()
    }
}

