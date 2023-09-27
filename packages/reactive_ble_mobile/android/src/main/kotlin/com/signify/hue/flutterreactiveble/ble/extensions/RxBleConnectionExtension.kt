package com.signify.hue.flutterreactiveble.ble.extensions

import android.bluetooth.BluetoothGattCharacteristic
import com.polidea.rxandroidble2.RxBleConnection
import io.reactivex.Single
import java.util.UUID

fun RxBleConnection.writeCharWithResponse(uuid: UUID, value: ByteArray): Single<ByteArray> =
        executeWrite(uuid, value, BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)

fun RxBleConnection.writeCharWithoutResponse(uuid: UUID, value: ByteArray): Single<ByteArray> =
        executeWrite(uuid, value, BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE)

private fun RxBleConnection.executeWrite(uuid: UUID, value: ByteArray, writeType: Int) =
        this.discoverServices().flatMap { services ->
            services.getCharacteristic(uuid).flatMap { char ->
                char.writeType = writeType
                this.writeCharacteristic(char, value)
            }
        }
