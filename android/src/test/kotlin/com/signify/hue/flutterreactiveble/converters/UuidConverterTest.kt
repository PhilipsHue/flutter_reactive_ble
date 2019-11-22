package com.signify.hue.flutterreactiveble.converters

import com.google.common.truth.Truth.assertThat
import org.junit.jupiter.api.Test
import java.util.*


class UuidConverterTest {

    val converter = UuidConverter()

    @Test
    fun `should convert uuid into bytearray`() {
        val uuid = UUID.randomUUID()
        val byteArray = converter.byteArrayFromUuid(uuid)
        val uuid2 = converter.uuidFromByteArray(byteArray)

        assertThat(uuid2).isEqualTo(uuid)
    }

    @Test
    fun `should be able to convert 16bit uuid`() {

        val array = byteArrayOf(0xFE.toByte(), 0x0F.toByte())
        val uuid = converter.uuidFromByteArray(array)
        assertThat(uuid.toString().toUpperCase()).isEqualTo("0000FE0F-0000-1000-8000-00805F9B34FB")
    }

    @Test
    fun `should be able to convert 32bit uuid`() {

        val array = byteArrayOf(0xFE.toByte(), 0x0F.toByte(), 0x0F.toByte(), 0xFE.toByte())
        val uuid = converter.uuidFromByteArray(array)
        assertThat(uuid.toString().toUpperCase()).isEqualTo("FE0F0FFE-0000-1000-8000-00805F9B34FB")
    }

    @Test
    fun `should convert bytearray into uuid`() {
        val uuid = UUID.randomUUID()

        val byteArray = converter.byteArrayFromUuid(uuid)
        assertThat(converter.uuidFromByteArray(byteArray).toString()).isEqualTo(uuid.toString())
    }
}
