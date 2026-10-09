package com.signify.hue.flutterreactiveble.ble.extensions

import android.bluetooth.BluetoothGattCharacteristic
import com.polidea.rxandroidble2.RxBleConnection
import io.reactivex.Single
import java.util.UUID

fun RxBleConnection.resolveCharacteristic(
    uuid: UUID,
    instanceId: Int,
): Single<BluetoothGattCharacteristic> =
    discoverServices().flatMap { services ->
        Single.just(
            services.bluetoothGattServices.flatMap { service ->
                service.characteristics.filter {
                    it.uuid == uuid && it.instanceId == instanceId
                }
            }.single(),
        )
    }

fun RxBleConnection.writeCharWithResponse(
    characteristic: BluetoothGattCharacteristic,
    value: ByteArray,
): Single<ByteArray> {
    characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
    return writeCharacteristic(characteristic, value)
}

fun RxBleConnection.writeCharWithoutResponse(
    characteristic: BluetoothGattCharacteristic,
    value: ByteArray,
): Single<ByteArray> {
    characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    return writeCharacteristic(characteristic, value)
}

// Splits value into packets of packetSize bytes (MTU-3 when packetSize is 0) and writes them back to back
// as a single queued operation, each packet sent as soon as the previous onCharacteristicWrite arrives
// (no Dart round trip).
fun RxBleConnection.writeCharWithoutResponseBatch(
    characteristic: BluetoothGattCharacteristic,
    value: ByteArray,
    packetSize: Int,
): Single<ByteArray> {
    characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    val builder = createNewLongWriteBuilder()
        .setCharacteristic(characteristic)
        .setBytes(value)
    if (packetSize > 0) builder.setMaxBatchSize(packetSize)
    return builder
        .build()
        .lastOrError()
}
