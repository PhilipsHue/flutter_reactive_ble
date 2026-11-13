package com.signify.hue.flutterreactiveble.ble

import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.google.common.truth.Truth.assertThat
import com.polidea.rxandroidble2.RxBleDevice
import io.mockk.CapturingSlot
import io.mockk.MockKAnnotations
import io.mockk.every
import io.mockk.impl.annotations.MockK
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ValueSource

@DisplayName("BondingManager unit tests")
class BondingManagerTest {
    @MockK
    private lateinit var context: Context

    @MockK
    private lateinit var device: RxBleDevice

    @MockK
    private lateinit var bluetoothDevice: BluetoothDevice

    private lateinit var sut: BondingManager

    @BeforeEach
    fun setup() {
        MockKAnnotations.init(this)

        every { bluetoothDevice.address }.returns("ab:cd:ef:12:34:56")
        every { device.bluetoothDevice }.returns(bluetoothDevice)
        every { context.unregisterReceiver(any()) }.returns(Unit)

        sut = BondingManager(context)
    }

    @Nested
    @DisplayName("Bonding => to success")
    inner class BondingSuccessTest {
        private val receiver: CapturingSlot<BroadcastReceiver> = CapturingSlot()

        @MockK
        private lateinit var deviceIntent: Intent

        @BeforeEach
        fun setup() {
            MockKAnnotations.init(this)

            every { bluetoothDevice.bondState }.returns(BluetoothDevice.BOND_NONE)
            every { context.registerReceiver(capture(receiver), any()) }.returns(null)
            every { bluetoothDevice.createBond() }.returns(true)
        }

        @ParameterizedTest
        @ValueSource(
            ints = [
                BluetoothDevice.BOND_BONDED,
                BluetoothDevice.BOND_NONE,
            ],
        )
        fun `emits the final bond state`(bondState: Int) {
            val result = sut.bondWithDevice(device).test()

            every { deviceIntent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, any()) }
                .returns(bondState)
            every { deviceIntent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE) }
                .returns(bluetoothDevice)

            receiver.captured.onReceive(context, deviceIntent)

            assertThat(result.errorCount()).isEqualTo(0)
            assertThat(result.values().first()).isEqualTo(bondState)
        }
    }

    @Nested
    @DisplayName("Already bonded")
    inner class AlreadyBondedTest {
        @BeforeEach
        fun setup() {
            every { bluetoothDevice.bondState }.returns(BluetoothDevice.BOND_BONDED)
        }

        @Test
        fun `immediately emits the current bond state`() {
            val result = sut.bondWithDevice(device).test()

            assertThat(result.errorCount()).isEqualTo(0)
            assertThat(result.values().first()).isEqualTo(BluetoothDevice.BOND_BONDED)
        }
    }

    @Nested
    @DisplayName("Bonding failed")
    inner class FailedBondingTest {
        @BeforeEach
        fun setup() {
            every { bluetoothDevice.bondState }.returns(BluetoothDevice.BOND_NONE)
            every { context.registerReceiver(any(), any()) }.returns(null)
            every { bluetoothDevice.createBond() }.returns(false)
        }

        @Test
        fun `emits a BondingFailedException`() {
            val result = sut.bondWithDevice(device).test()

            assertThat(result.errorCount()).isEqualTo(1)
            assertThat(result.errors().first()).isInstanceOf(BondingFailedException::class.java)
        }
    }
}
