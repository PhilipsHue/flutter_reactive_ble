package com.signify.hue.flutterreactiveble.converters

import android.util.SparseArray

fun extractManufacturerData(manufacturerData: SparseArray<ByteArray>?): ByteArray {
    val rawData = mutableListOf<Byte>()

    if (manufacturerData != null && manufacturerData.size() > 0) {
        var pos = 0
        for (i in 0 until manufacturerData.size()) {
            val companyId = manufacturerData.keyAt(i)
            val payload = manufacturerData.get(companyId)
            rawData.add((companyId.toByte()))
            rawData.add(((companyId.shr(Byte.SIZE_BITS)).toByte()))
            pos += 2
            val list = payload.asList()
            rawData.addAll(pos, list)
            pos += list.size
        }
    }

    return rawData.toByteArray()
}
