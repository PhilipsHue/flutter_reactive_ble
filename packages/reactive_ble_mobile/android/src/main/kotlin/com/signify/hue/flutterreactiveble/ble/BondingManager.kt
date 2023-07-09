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
 * Created by clement on 2017-08-24.
 */

class BondingFailedException : RuntimeException()

object BondingManager {
    /**
     * @throws BondingFailedException
     */
    // TODO: try to understand why the popup is being displayed in the notification center (sometimes) ???!!!
    @SuppressLint("MissingPermission")
    fun bondWithDevice(
        context: Context,
        rxBleDevice: RxBleDevice
    ): Single<Int> {
        return Single.create { completion ->
            when (rxBleDevice.bluetoothDevice.bondState) {
                BluetoothDevice.BOND_BONDED -> completion.onSuccess(BluetoothDevice.BOND_BONDED)
                else -> {

                    val receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context, intent: Intent) {
                            val deviceBeingPaired: BluetoothDevice? =
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                    intent.getParcelableExtra(
                                        BluetoothDevice.EXTRA_DEVICE,
                                        BluetoothDevice::class.java
                                    )
                                } else {
                                    @Suppress("DEPRECATION")
                                    intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                                }

                            if (deviceBeingPaired?.address == rxBleDevice.bluetoothDevice.address) {
                                val state = intent.getIntExtra(
                                    BluetoothDevice.EXTRA_BOND_STATE,
                                    BluetoothDevice.BOND_NONE
                                )

                                when (state) {
                                    BluetoothDevice.BOND_BONDED -> completion.onSuccess(state)
                                    BluetoothDevice.BOND_NONE -> completion.onSuccess(state)
                                    // BOND_BONDING is a intermediate state - do not send this back.
                                }
                            }
                        }
                    }

                    completion.setDisposable(Disposables.fromAction {
                        context.unregisterReceiver(
                            receiver
                        )
                    })

                    context.registerReceiver(
                        receiver,
                        IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
                    )

                    val createBondResult = rxBleDevice.bluetoothDevice.createBond()

                    if (!createBondResult) {
                        completion.tryOnError(BondingFailedException())
                    }

                }
            }

        }

    }
}
