package com.signify.hue.flutterreactiveble.ble

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.BroadcastReceiver
import android.os.Build
import android.util.Log
import com.polidea.rxandroidble2.RxBleDevice
import com.signify.hue.flutterreactiveble.model.BondingMode
import io.reactivex.Completable
import io.reactivex.disposables.Disposables

/**
 * Created by clement on 2017-08-24.
 */

class BondingFailedException : RuntimeException()

object BondingManager {
    const val TAG = "CompanionHandler"

    /**
     * @throws BondingFailedException
     */
    // TODO: try to understand why the popup is being displayed in the notification center (sometimes) ???!!!
    @SuppressLint("MissingPermission")
    fun bondWithDevice(
        context: Context,
        rxBleDevice: RxBleDevice,
        bondingMode: BondingMode
    ): Completable {
        if (bondingMode == BondingMode.NONE) {
            return Completable.complete()
        }

        return Completable.create { completion ->
            Log.d(TAG, "pairWithDevice: ${rxBleDevice.bluetoothDevice.bondState}")
            when (rxBleDevice.bluetoothDevice.bondState) {
                BluetoothDevice.BOND_BONDED -> completion.onComplete()
                else -> {

                    val receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context, intent: Intent) {
                            val deviceBeingPaired: BluetoothDevice? =
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                    intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE, BluetoothDevice::class.java)
                                } else {
                                    @Suppress("DEPRECATION")
                                    intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                                }

                            Log.d(TAG, "pairWithDevice: deviceBeingPaired: $deviceBeingPaired")

                            if (deviceBeingPaired?.address == rxBleDevice.bluetoothDevice.address) {
                                val state = intent.getIntExtra(
                                    BluetoothDevice.EXTRA_BOND_STATE,
                                    BluetoothDevice.BOND_NONE
                                )

                                Log.d(TAG, "pairWithDevice: state: $state")

                                when (state) {
                                    BluetoothDevice.BOND_BONDED -> completion.onComplete()
                                    BluetoothDevice.BOND_NONE ->
                                        // When bonding is required, we throw an exception if the bonding fails.
                                        if (bondingMode == BondingMode.REQUIRED) {
                                            completion.tryOnError(BondingFailedException())
                                        } else { // BondingMode.NOT_REQUIRED
                                            completion.onComplete()
                                        }
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

                    Log.d(TAG, "pairWithDevice: createBondResult: $createBondResult")

                    if (!createBondResult) {
                        completion.tryOnError(BondingFailedException())
                    }

                }
            }

        }

    }
}
