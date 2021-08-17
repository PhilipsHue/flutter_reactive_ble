package com.signify.hue.flutterreactiveble.utils

import com.polidea.rxandroidble2.RxBleClient
import com.polidea.rxandroidble2.RxBleClient.State.BLUETOOTH_NOT_AVAILABLE
import com.polidea.rxandroidble2.RxBleClient.State.BLUETOOTH_NOT_ENABLED
import com.polidea.rxandroidble2.RxBleClient.State.LOCATION_PERMISSION_NOT_GRANTED
import com.polidea.rxandroidble2.RxBleClient.State.LOCATION_SERVICES_NOT_ENABLED
import com.polidea.rxandroidble2.RxBleClient.State.READY
import com.signify.hue.flutterreactiveble.ble.BleStatus
import com.signify.hue.flutterreactiveble.ble.ConnectionPriority

fun RxBleClient.State.toBleState(): BleStatus =
        when (this) {
            BLUETOOTH_NOT_AVAILABLE -> BleStatus.UNSUPPORTED
            LOCATION_PERMISSION_NOT_GRANTED -> BleStatus.UNAUTHORIZED
            BLUETOOTH_NOT_ENABLED -> BleStatus.POWERED_OFF
            LOCATION_SERVICES_NOT_ENABLED -> BleStatus.LOCATION_SERVICES_DISABLED
            READY -> BleStatus.READY
        }

fun Int.toConnectionPriority() =
        when (this) {
            0 -> ConnectionPriority.BALANCED
            1 -> ConnectionPriority.HIGH_PERFORMACE
            2 -> ConnectionPriority.LOW_POWER
            else -> ConnectionPriority.BALANCED
        }
