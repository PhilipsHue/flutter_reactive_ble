package com.signify.hue.flutterreactiveble.ble

import com.polidea.rxandroidble2.RxBleConnection
import java.util.UUID

data class ScanInfo(val deviceId: String, val name: String, val rssi: Int, val serviceData: Map<UUID, ByteArray>, val manufacturerData: ByteArray) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ScanInfo

        if (deviceId != other.deviceId) return false
        if (name != other.name) return false
        if (rssi != other.rssi) return false
        if (serviceData != other.serviceData) return false
        if (!manufacturerData.contentEquals(other.manufacturerData)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = deviceId.hashCode()
        result = 31 * result + name.hashCode()
        result = 31 * result + rssi
        result = 31 * result + serviceData.hashCode()
        result = 31 * result + manufacturerData.contentHashCode()
        return result
    }
}

sealed class ConnectionUpdate
data class ConnectionUpdateSuccess(val deviceId: String, val connectionState: Int) : com.signify.hue.flutterreactiveble.ble.ConnectionUpdate()
data class ConnectionUpdateError(val deviceId: String, val errorMessage: String) : com.signify.hue.flutterreactiveble.ble.ConnectionUpdate()

sealed class EstablishConnectionResult
data class EstablishedConnection(val deviceId: String, val rxConnection: RxBleConnection) : com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult()
data class EstablishConnectionFailure(val deviceId: String, val errorMessage: String) : com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult()

sealed class MtuNegotiateResult
data class MtuNegotiateSuccesful(val deviceId: String, val size: Int) : com.signify.hue.flutterreactiveble.ble.MtuNegotiateResult()
data class MtuNegotiateFailed(val deviceId: String, val errorMessage: String) : com.signify.hue.flutterreactiveble.ble.MtuNegotiateResult()

sealed class CharOperationResult
data class CharOperationSuccessful(val deviceId: String, val value: List<Byte>) : com.signify.hue.flutterreactiveble.ble.CharOperationResult()
data class CharOperationFailed(val deviceId: String, val errorMessage: String) : com.signify.hue.flutterreactiveble.ble.CharOperationResult()

sealed class RequestConnectionPriorityResult
data class RequestConnectionPrioritySuccess(val deviceId: String) : com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityResult()
data class RequestConnectionPriorityFailed(val deviceId: String, val errorMessage: String) : com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityResult()

enum class BleStatus(val code: Int) {
    UNKNOWN(code = 0),
    UNSUPPORTED(code = 1),
    UNAUTHORIZED(code = 2),
    POWERED_OFF(code = 3),
    DISCOVERY_DISABLED(code = 4),
    READY(code = 5)
}

enum class ConnectionPriority(val code: Int) {
    BALANCED(code = 0),
    HIGH_PERFORMACE(code = 1),
    LOW_POWER(code = 2)
}
