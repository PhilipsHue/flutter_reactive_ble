package com.signify.hue.flutterreactiveble.model

import android.bluetooth.le.ScanSettings

enum class ScanMode(val code: Int) {
    OPPORTUNISTIC(-1),
    LOW_POWER(0),
    BALANCED(1),
    LOW_LATENCY(2)
}

internal fun ScanMode.toScanSettings(): Int =
    when (this) {
        ScanMode.OPPORTUNISTIC -> ScanSettings.SCAN_MODE_OPPORTUNISTIC
        ScanMode.LOW_POWER -> ScanSettings.SCAN_MODE_LOW_POWER
        ScanMode.BALANCED -> ScanSettings.SCAN_MODE_BALANCED
        ScanMode.LOW_LATENCY -> ScanSettings.SCAN_MODE_LOW_LATENCY
    }

internal fun createScanMode(mode: Int): ScanMode =
        when (mode) {
            -1 -> ScanMode.OPPORTUNISTIC
            0 -> ScanMode.LOW_POWER
            1 -> ScanMode.BALANCED
            2 -> ScanMode.LOW_LATENCY
            else -> ScanMode.LOW_POWER
        }
