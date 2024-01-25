package com.signify.hue.flutterreactiveble.ble

import android.os.ParcelUuid
import com.polidea.rxandroidble2.RxBleDeviceServices
import com.signify.hue.flutterreactiveble.model.ScanMode
import com.signify.hue.flutterreactiveble.utils.Duration
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.subjects.BehaviorSubject
import java.util.UUID

@Suppress("TooManyFunctions")
interface BleClient {

    val connectionUpdateSubject: BehaviorSubject<ConnectionUpdate>

    fun initializeClient()
    fun scanForDevices(services: List<ParcelUuid>, scanMode: ScanMode, requireLocationServicesEnabled: Boolean): Observable<ScanInfo>
    fun connectToDevice(deviceId: String, timeout: Duration)
    fun disconnectDevice(deviceId: String)
    fun disconnectAllDevices()
    fun discoverServices(deviceId: String): Single<RxBleDeviceServices>
    fun clearGattCache(deviceId: String): Completable
    fun readCharacteristic(
        deviceId: String,
        characteristicId: UUID,
        characteristicInstanceId: Int
    ): Single<CharOperationResult>
    fun setupNotification(
        deviceId: String,
        characteristicId: UUID,
        characteristicInstanceId: Int
    ): Observable<ByteArray>
    fun writeCharacteristicWithResponse(
        deviceId: String,
        characteristicId: UUID,
        characteristicInstanceId: Int,
        value: ByteArray
    ): Single<CharOperationResult>
    fun writeCharacteristicWithoutResponse(
        deviceId: String,
        characteristicId: UUID,
        characteristicInstanceId: Int,
        value: ByteArray
    ): Single<CharOperationResult>
    fun negotiateMtuSize(deviceId: String, size: Int): Single<MtuNegotiateResult>
    fun observeBleStatus(): Observable<BleStatus>
    fun requestConnectionPriority(deviceId: String, priority: ConnectionPriority):
            Single<RequestConnectionPriorityResult>
    fun readRssi(deviceId: String): Single<Int>
}
