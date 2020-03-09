package com.signify.hue.flutterreactiveble.ble

import android.os.ParcelUuid
import com.signify.hue.flutterreactiveble.model.ScanMode
import com.signify.hue.flutterreactiveble.utils.Duration
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.subjects.BehaviorSubject
import java.util.UUID

@Suppress("TooManyFunctions")
interface BleClient {

    val connectionUpdateSubject: BehaviorSubject<com.signify.hue.flutterreactiveble.ble.ConnectionUpdate>

    fun initializeClient()
    fun scanForDevices(services: List<ParcelUuid>, scanMode: ScanMode, requireLocationServicesEnabled: Boolean): Observable<com.signify.hue.flutterreactiveble.ble.ScanInfo>
    fun connectToDevice(deviceId: String, timeout: Duration)
    fun disconnectDevice(deviceId: String)
    fun disconnectAllDevices()
    fun clearGattCache(deviceId: String): Completable
    fun readCharacteristic(deviceId: String, characteristic: UUID): Single<com.signify.hue.flutterreactiveble.ble.CharOperationResult>
    fun setupNotification(deviceId: String, characteristic: UUID): Observable<ByteArray>
    fun writeCharacteristicWithResponse(
        deviceId: String,
        characteristic: UUID,
        value: ByteArray
    ): Single<com.signify.hue.flutterreactiveble.ble.CharOperationResult>
    fun writeCharacteristicWithoutResponse(
        deviceId: String,
        characteristic: UUID,
        value: ByteArray
    ): Single<com.signify.hue.flutterreactiveble.ble.CharOperationResult>
    fun negotiateMtuSize(deviceId: String, size: Int): Single<com.signify.hue.flutterreactiveble.ble.MtuNegotiateResult>
    fun observeBleStatus(): Observable<com.signify.hue.flutterreactiveble.ble.BleStatus>
    fun requestConnectionPriority(deviceId: String, priority: com.signify.hue.flutterreactiveble.ble.ConnectionPriority):
            Single<com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityResult>
}
