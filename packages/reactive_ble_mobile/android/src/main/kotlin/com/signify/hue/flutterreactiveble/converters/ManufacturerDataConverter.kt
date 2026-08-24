package com.signify.hue.flutterreactiveble.converters

import android.util.SparseArray

fun extractManufacturerData(manufacturerData: SparseArray<ByteArray>?): ByteArray {
    val rawData = mutableListOf<Byte>()

    if (manufacturerData != null && manufacturerData.size() > 0) {
        val companyId = manufacturerData.keyAt(0)
        rawData.add((companyId.toByte()))
        rawData.add(((companyId.shr(Byte.SIZE_BITS)).toByte()))
        rawData.addAll(manufacturerData.valueAt(0).asList())

        for (i in 1 until manufacturerData.size()) {
            rawData.addAll(manufacturerData.valueAt(i).asList())
        }
    }

    return rawData.toByteArray()
}
