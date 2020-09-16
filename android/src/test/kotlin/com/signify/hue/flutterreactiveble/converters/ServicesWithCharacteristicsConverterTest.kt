package com.signify.hue.flutterreactiveble.converters

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import com.google.common.truth.Truth.assertThat
import com.polidea.rxandroidble2.RxBleDeviceServices
import io.mockk.MockKAnnotations
import io.mockk.every
import io.mockk.impl.annotations.MockK
import org.junit.Before
import org.junit.Test
import java.util.UUID
import com.signify.hue.flutterreactiveble.ProtobufModel as pb


class ServicesWithCharacteristicsConverterTest {

    private val serviceUuid = UUID.randomUUID()
    private val characteristicUuid = UUID.randomUUID()
    private val internalCharacteristicUuid = UUID.randomUUID()
    private val internalServiceUuid = UUID.randomUUID()
    private val internalCharacteristicUuidLevel2 = UUID.randomUUID()
    private val internalServiceUuidLevel2 = UUID.randomUUID()
    private val sut = ProtobufMessageConverter()
    private lateinit var conversionResult: pb.DiscoverServicesInfo

    @MockK
    lateinit var service: BluetoothGattService

    @MockK
    lateinit var characteristic: BluetoothGattCharacteristic

    @MockK
    lateinit var internalService: BluetoothGattService

    @MockK
    lateinit var internalCharacteristic: BluetoothGattCharacteristic

    @MockK
    lateinit var internalServiceLevel2: BluetoothGattService

    @MockK
    lateinit var internalCharacteristicLevel2: BluetoothGattCharacteristic


    @Before
    fun setUp() {
        MockKAnnotations.init(this)
        every { service.uuid }.returns(serviceUuid)
        every { characteristic.uuid }.returns(characteristicUuid)
        every { service.includedServices }.returns(listOf(internalService))
        every { service.characteristics }.returns(listOf(characteristic))

        every { internalCharacteristic.uuid }.returns(internalCharacteristicUuid)
        every { internalService.uuid }.returns(internalServiceUuid)
        every { internalService.includedServices }.returns(listOf(internalServiceLevel2, internalServiceLevel2))
        every { internalService.characteristics }.returns(listOf(internalCharacteristic))

        every { internalCharacteristicLevel2.uuid }.returns(internalCharacteristicUuidLevel2)
        every { internalServiceLevel2.uuid }.returns(internalServiceUuidLevel2)
        every { internalServiceLevel2.includedServices }.returns(listOf())
        every { internalServiceLevel2.characteristics }.returns(listOf(internalCharacteristicLevel2))

        conversionResult = sut.convertDiscoverServicesInfo("test",
                RxBleDeviceServices(listOf(service)))
    }

    @Test
    fun `It converts total services`() {
        assertThat(conversionResult.servicesCount).isEqualTo(1)
    }

    @Test
    fun `It converts characteristic uuid`() {
        assertThat(conversionResult.getServices(0).characteristicUuidsCount).isEqualTo(1)
    }


    @Test
    fun `It converts nested internal services correctly`() {
        assertThat(conversionResult.getServices(0).getIncludedServices(0)
                .includedServicesCount).isEqualTo(2)
    }
}

