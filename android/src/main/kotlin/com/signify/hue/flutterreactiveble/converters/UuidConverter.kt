package com.signify.hue.flutterreactiveble.converters

import java.nio.ByteBuffer
import java.util.UUID

class UuidConverter {
    companion object {
        private const val byteSize16Bit = 2
        private const val byteSize32Bit = 4
        private const val byteBufferSize = 16
    }

    fun uuidFromByteArray(bytes: ByteArray): UUID {

        return when (bytes.size) {
            byteSize16Bit -> convert16BitToUuid(bytes)
            byteSize32Bit -> convert32BitToUuid(bytes)
            else -> convert128BitNotationToUuid(bytes)
        }
    }

    @Suppress("Detekt.MagicNumber")
    private fun convert16BitToUuid(bytes: ByteArray): UUID {
        // UUID construction is retrieved from BLE corespec v5.0 page 1917
        val uuidConstruct = byteArrayOf(0x00, 0x00, bytes[0], bytes[1], 0x00, 0x00, 0x10, 0x00,
                0x80.toByte(), 0x00, 0x00, 0x80.toByte(), 0x5F, 0x9B.toByte(), 0x34, 0xFB.toByte())

        return convert128BitNotationToUuid(uuidConstruct)
    }

    @Suppress("Detekt.MagicNumber")
    private fun convert32BitToUuid(bytes: ByteArray): UUID {
        val uuidConstruct = byteArrayOf(bytes[0], bytes[1], bytes[2], bytes[3], 0x00, 0x00, 0x10, 0x00,
                0x80.toByte(), 0x00, 0x00, 0x80.toByte(), 0x5F, 0x9B.toByte(), 0x34, 0xFB.toByte())

        return convert128BitNotationToUuid(uuidConstruct)
    }

    private fun convert128BitNotationToUuid(bytes: ByteArray): UUID {
        val bb = ByteBuffer.wrap(bytes)
        val most = bb.long
        val least = bb.long
        return UUID(most, least)
    }

    fun byteArrayFromUuid(uuid: UUID): ByteArray {
        val bb = ByteBuffer.wrap(ByteArray(byteBufferSize))
        bb.putLong(uuid.mostSignificantBits)
        bb.putLong(uuid.leastSignificantBits)

        return bb.array()
    }
}
