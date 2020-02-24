package com.signify.hue.flutterreactiveble.channelhandlers

import android.os.ParcelUuid
import com.signify.hue.flutterreactiveble.ProtobufModel as pb
import com.signify.hue.flutterreactiveble.converters.ProtobufMessageConverter
import com.signify.hue.flutterreactiveble.converters.UuidConverter
import com.signify.hue.flutterreactiveble.model.ScanMode
import com.signify.hue.flutterreactiveble.model.createScanMode
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import timber.log.Timber

class ScanDevicesHandler(private val bleClient: com.signify.hue.flutterreactiveble.ble.BleClient) : EventChannel.StreamHandler {

    private var scanDevicesSink: EventChannel.EventSink? = null
    private lateinit var scanForDevicesDisposable: Disposable
    private val converter = ProtobufMessageConverter()
    private var scanParameters: ScanParameters? = null

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {

        eventSink?.let {
            scanDevicesSink = eventSink
            startDeviceScan()
        }
    }

    override fun onCancel(objectSink: Any?) {
        Timber.d("Scanfordevices cancelled called")
        stopDeviceScan()
        scanDevicesSink = null
    }

    private fun startDeviceScan() {
        scanParameters?.let { params ->
            scanForDevicesDisposable = bleClient.scanForDevices(params.filter, params.mode, params.locationServiceIsMandatory)
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(
                            { scanResult ->
                                handleDeviceScanResult(converter.convertScanInfo(scanResult))
                            },
                            { throwable ->

                                Timber.d("Error while scanning for devices:  ${throwable.message}")
                                handleDeviceScanResult(converter.convertScanErrorInfo(throwable.message))
                            }
                    )
        }
                ?: handleDeviceScanResult(converter.convertScanErrorInfo("Scanparameters are not being set"))
    }

    fun stopDeviceScan() {
        scanForDevicesDisposable.dispose()
        scanParameters = null
    }

    fun prepareScan(scanMessage: pb.ScanForDevicesRequest) {
        val filter = scanMessage.serviceUuidsList
                .map { ParcelUuid(UuidConverter().uuidFromByteArray(it.data.toByteArray())) }
        val scanMode = createScanMode(scanMessage.scanMode)

        scanParameters = ScanParameters(filter, scanMode, scanMessage.requireLocationServicesEnabled)
    }

    private fun handleDeviceScanResult(discoveryMessage: pb.DeviceScanInfo) {
        scanDevicesSink?.success(discoveryMessage.toByteArray())
    }
}

private data class ScanParameters(val filter: List<ParcelUuid>, val mode: ScanMode, val locationServiceIsMandatory: Boolean)
