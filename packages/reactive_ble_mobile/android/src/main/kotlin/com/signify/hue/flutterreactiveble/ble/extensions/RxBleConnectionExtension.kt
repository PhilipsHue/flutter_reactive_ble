package com.signify.hue.flutterreactiveble.ble.extensions

import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothGattCharacteristic
import com.polidea.rxandroidble2.RxBleConnection
import io.reactivex.Single
import java.util.UUID

fun RxBleConnection.writeCharWithResponse(serviceUuid: UUID, charUuid: UUID, value: ByteArray): Single<ByteArray> =
        executeWrite(serviceUuid, charUuid, value, BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)

fun RxBleConnection.writeCharWithoutResponse(serviceUuid: UUID, charUuid: UUID, value: ByteArray): Single<ByteArray> =
        executeWrite(serviceUuid, charUuid, value, BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE)

fun RxBleConnection.readChar(serviceUuid: UUID, charUuid: UUID) =
    this.discoverServices().flatMap {
            services -> services.getService(serviceUuid)}.map{
            service -> service.getCharacteristic(charUuid)}
        .flatMap { characteristic -> this.readCharacteristic(characteristic) }

private fun RxBleConnection.executeWrite(serviceUuid: UUID, charUuid: UUID, value: ByteArray, writeType: Int) =
        this.discoverServices().flatMap {
                services -> services.getService(serviceUuid)}.map{
            service -> service.getCharacteristic(charUuid)}
            .flatMap { characteristic ->
                characteristic.writeType = writeType
                this.writeCharacteristic(characteristic, value) }
            /*
            services.getCharacteristic(uuid).flatMap { char ->
                char.writeType = writeType
                this.writeCharacteristic(char, value)
            }
            */
        //}

