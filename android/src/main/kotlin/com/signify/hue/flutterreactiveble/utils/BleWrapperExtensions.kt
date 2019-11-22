package com.signify.hue.flutterreactiveble.utils

import com.polidea.rxandroidble2.RxBleClient
import com.polidea.rxandroidble2.RxBleClient.State.BLUETOOTH_NOT_AVAILABLE
import com.polidea.rxandroidble2.RxBleClient.State.BLUETOOTH_NOT_ENABLED
import com.polidea.rxandroidble2.RxBleClient.State.LOCATION_PERMISSION_NOT_GRANTED
import com.polidea.rxandroidble2.RxBleClient.State.LOCATION_SERVICES_NOT_ENABLED
import com.polidea.rxandroidble2.RxBleClient.State.READY
import com.signify.hue.flutterreactiveble.ble.BleStatus
import com.signify.hue.flutterreactiveble.ble.ConnectionPriority

fun RxBleClient.State.toBleState(): com.signify.hue.flutterreactiveble.ble.BleStatus =
        when (this) {
            BLUETOOTH_NOT_AVAILABLE -> com.signify.hue.flutterreactiveble.ble.BleStatus.UNSUPPORTED
            LOCATION_PERMISSION_NOT_GRANTED -> com.signify.hue.flutterreactiveble.ble.BleStatus.UNAUTHORIZED
            BLUETOOTH_NOT_ENABLED -> com.signify.hue.flutterreactiveble.ble.BleStatus.POWERED_OFF
            LOCATION_SERVICES_NOT_ENABLED -> com.signify.hue.flutterreactiveble.ble.BleStatus.DISCOVERY_DISABLED
            READY -> com.signify.hue.flutterreactiveble.ble.BleStatus.READY
        }

fun Int.toConnectionPriority() =
        when (this) {
            0 -> com.signify.hue.flutterreactiveble.ble.ConnectionPriority.BALANCED
            1 -> com.signify.hue.flutterreactiveble.ble.ConnectionPriority.HIGH_PERFORMACE
            2 -> com.signify.hue.flutterreactiveble.ble.ConnectionPriority.LOW_POWER
            else -> com.signify.hue.flutterreactiveble.ble.ConnectionPriority.BALANCED
        }
