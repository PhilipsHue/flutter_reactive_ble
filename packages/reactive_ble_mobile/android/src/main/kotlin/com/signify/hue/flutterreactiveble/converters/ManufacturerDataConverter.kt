package com.signify.hue.flutterreactiveble.converters

import android.util.SparseArray

fun extractManufacturerData(manufacturerData: SparseArray<ByteArray>?): ByteArray {
    val rawData = mutableListOf<Byte>()

    if (manufacturerData != null && manufacturerData.size() > 0) {
        val companyId = manufacturerData.keyAt(0)
        val payload = manufacturerData.get(companyId)

        rawData.add((companyId.toByte()))
        rawData.add(((companyId.shr(Byte.SIZE_BITS)).toByte()))
        rawData.addAll(2, payload.asList())
    }

    return rawData.toByteArray()
}
