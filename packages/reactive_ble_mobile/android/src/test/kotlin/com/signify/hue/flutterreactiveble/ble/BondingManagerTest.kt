package com.signify.hue.flutterreactiveble.ble

import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
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

        sut = BondingManager(context)
    }

    @Nested
    @DisplayName("Bonding => to success")
    inner class BondingSuccessTest {
        private var receiver: CapturingSlot<BroadcastReceiver> = CapturingSlot()

        @BeforeEach
        fun setup() {
            MockKAnnotations.init(this)

            every { bluetoothDevice.bondState }.returns(BluetoothDevice.BOND_NONE)
            every { context.registerReceiver(capture(receiver), any()) }.returns(null)
            every { bluetoothDevice.createBond() }.returns(true)
            every { context.unregisterReceiver(any()) }.returns(Unit)
        }

        @MockK
        private lateinit var deviceIntent: Intent

        @ParameterizedTest
        @DisplayName("create bond")
        @ValueSource(
            ints = [
                BluetoothDevice.BOND_BONDED,
                BluetoothDevice.BOND_NONE,
            ],
        )
        fun createBond(bondState: Int) {
            val result = sut.bondWithDevice(device).test()

            every { deviceIntent.action }.returns(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
            every { deviceIntent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, any()) }.returns(
                bondState,
            )
            every { deviceIntent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE) }.returns(
                bluetoothDevice,
            )

            receiver.captured.onReceive(context, deviceIntent)

            assert(result.errorCount() == 0)
            assert(result.values()[0] == bondState)
        }
    }

    @Nested
    @DisplayName("Already bonded")
    inner class AlreadyBonded {
        @BeforeEach
        fun setup() {
            every { bluetoothDevice.bondState }.returns(BluetoothDevice.BOND_BONDED)
        }

        @Test
        @DisplayName("create bond")
        fun createBond() {
            val result = sut.bondWithDevice(device).test()
            assert(result.errorCount() == 0)
            assert(result.values()[0] == BluetoothDevice.BOND_BONDED)
        }
    }

    @Nested
    @DisplayName("Bonding Failed")
    inner class FailedBondingTest {
        @BeforeEach
        fun setup() {
            every { bluetoothDevice.bondState }.returns(BluetoothDevice.BOND_NONE)
            every { context.registerReceiver(any(), any()) }.returns(null)
            every { bluetoothDevice.createBond() }.returns(false)
        }

        @Test
        @DisplayName("create bond")
        fun createBond() {
            val result = sut.bondWithDevice(device).test()
            assert(result.errorCount() == 1)
            assert(result.errors().first() is BondingFailedException)
        }
    }
}
