package com.signify.hue.flutterreactiveble.channelhandlers

import android.app.Activity
import android.bluetooth.le.ScanResult
import android.companion.AssociationInfo
import android.companion.AssociationRequest
import android.companion.BluetoothLeDeviceFilter
import android.companion.CompanionDeviceManager
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.signify.hue.flutterreactiveble.ProtobufModel
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.concurrent.Executor
import java.util.regex.Pattern

class CompanionHandler {
    companion object {
        const val SELECT_DEVICE_REQUEST_CODE = 4389
        const val TAG = "CompanionHandler"
    }

    private var activity = WeakReference<Activity>(null)

    private var tmpResult: MethodChannel.Result? = null

    @RequiresApi(Build.VERSION_CODES.O)
    fun launchCompanionFlow(
        parseFrom: ProtobufModel.LaunchCompanionRequest,
        result: MethodChannel.Result
    ) {
        val deviceFilter: BluetoothLeDeviceFilter = BluetoothLeDeviceFilter.Builder()
            .setNamePattern(Pattern.compile(parseFrom.deviceNamePattern))
            .build()

        val pairingRequestBuilder = AssociationRequest.Builder()
            .addDeviceFilter(deviceFilter)
            .setSingleDevice(parseFrom.singleDeviceScan)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pairingRequestBuilder.setForceConfirmation(parseFrom.forceConfirmation)
        }

        val activity = activity.get() ?: return result.error(
            "CompanionHandler",
            "Activity is null",
            null
        )

        val deviceManager =
            activity.getSystemService(Context.COMPANION_DEVICE_SERVICE) as CompanionDeviceManager

        val executor = Executor { it.run() }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            deviceManager.associate(pairingRequestBuilder.build(),
                executor,
                object : CompanionDeviceManager.Callback() {
                    override fun onAssociationPending(intentSender: IntentSender) {
                        activity.startIntentSenderForResult(
                            intentSender,
                            SELECT_DEVICE_REQUEST_CODE,
                            null,
                            0,
                            0,
                            0
                        )
                    }

                    override fun onAssociationCreated(associationInfo: AssociationInfo) {
                        result.success(
                            ProtobufModel.DeviceAssociationInfo.newBuilder()
                                .setMacAddress(
                                    associationInfo.deviceMacAddress!!.toString().uppercase()
                                )
                                .build()
                                .toByteArray()
                        )
                    }

                    override fun onFailure(errorMessage: CharSequence?) {
                        Log.e(TAG, "onFailure: $errorMessage")
                        result.error("CompanionHandler", errorMessage.toString(), null)
                    }
                })
        } else {
            deviceManager.associate(
                pairingRequestBuilder.build(),
                object : CompanionDeviceManager.Callback() {
                    @Deprecated("Deprecated in Java")
                    override fun onDeviceFound(chooserLauncher: IntentSender) {
                        tmpResult = result
                        activity.startIntentSenderForResult(
                            chooserLauncher,
                            SELECT_DEVICE_REQUEST_CODE, null, 0, 0, 0
                        )
                    }

                    override fun onFailure(error: CharSequence?) {
                        Log.e(TAG, "onFailure: $error")
                        result.error("CompanionHandler", error.toString(), null)
                    }
                }, null
            )
        }
    }

    fun setActivity(activity: Activity?) {
        this.activity = WeakReference(activity);
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun onActivityResult(data: Intent?): ScanResult? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val associationInfo = data?.getParcelableExtra(
                CompanionDeviceManager.EXTRA_ASSOCIATION,
                AssociationInfo::class.java
            )

            Log.d(TAG, "onActivityResult: ${associationInfo?.id}")
            Log.d(TAG, "onActivityResult: ${associationInfo?.displayName}")
            Log.d(TAG, "onActivityResult: ${associationInfo?.deviceMacAddress}")
            Log.d(TAG, "onActivityResult: ${associationInfo?.deviceProfile}")

            null
        } else {
            @Suppress("DEPRECATION")
            val scanResult: ScanResult? =
                data?.getParcelableExtra(CompanionDeviceManager.EXTRA_DEVICE)


            if (scanResult != null) {
                tmpResult?.success(
                    ProtobufModel.DeviceAssociationInfo.newBuilder()
                        .setMacAddress(scanResult.device.address.uppercase())
                        .build()
                        .toByteArray()
                )

                tmpResult = null
            }

            null
        }
    }
}