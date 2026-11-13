package com.signify.hue.flutterreactiveble.ble

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import com.polidea.rxandroidble2.RxBleDevice
import io.reactivex.Single
import io.reactivex.disposables.Disposables

/**
 * Thrown when the creation of a bond with a peripheral failed.
 */
class BondingFailedException : RuntimeException()

/**
 * Creates bonds (pairings) with BLE peripherals.
 *
 * Kept as a class (rather than an object) so that it can be (mock) tested and so
 * that a [Context] can be injected.
 */
class BondingManager(private val context: Context) {
    /**
     * Creates a bond with the given [rxBleDevice].
     *
     * The returned [Single] emits the final
     * [android.bluetooth.BluetoothDevice.getBondState] of the device, i.e. one
     * of [android.bluetooth.BluetoothDevice.BOND_BONDED] or
     * [android.bluetooth.BluetoothDevice.BOND_NONE]. When the device is already
     * bonded the current state is emitted immediately.
     *
     * @throws BondingFailedException when the bond request could not be started.
     */
    @SuppressLint("MissingPermission")
    fun bondWithDevice(rxBleDevice: RxBleDevice): Single<Int> {
        return Single.create { completion ->
            if (rxBleDevice.bluetoothDevice.bondState == BluetoothDevice.BOND_BONDED) {
                completion.onSuccess(BluetoothDevice.BOND_BONDED)
                return@create
            }

            val receiver =
                object : BroadcastReceiver() {
                    override fun onReceive(
                        context: Context,
                        intent: Intent,
                    ) {
                        val deviceBeingPaired: BluetoothDevice? =
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                intent.getParcelableExtra(
                                    BluetoothDevice.EXTRA_DEVICE,
                                    BluetoothDevice::class.java,
                                )
                            } else {
                                @Suppress("DEPRECATION")
                                intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                            }

                        if (deviceBeingPaired?.address == rxBleDevice.bluetoothDevice.address) {
                            val state =
                                intent.getIntExtra(
                                    BluetoothDevice.EXTRA_BOND_STATE,
                                    BluetoothDevice.BOND_NONE,
                                )

                            when (state) {
                                BluetoothDevice.BOND_BONDED -> completion.onSuccess(state)
                                BluetoothDevice.BOND_NONE -> completion.onSuccess(state)
                                // BOND_BONDING is a intermediate state - do not send this back.
                            }
                        }
                    }
                }

            completion.setDisposable(
                Disposables.fromAction {
                    context.unregisterReceiver(receiver)
                },
            )

            context.registerReceiver(
                receiver,
                IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED),
            )

            val createBondResult = rxBleDevice.bluetoothDevice.createBond()

            if (!createBondResult) {
                completion.tryOnError(BondingFailedException())
            }
        }
    }
}
