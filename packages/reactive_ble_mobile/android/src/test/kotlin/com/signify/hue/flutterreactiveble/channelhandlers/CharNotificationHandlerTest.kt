package com.signify.hue.flutterreactiveble.channelhandlers

import com.google.common.truth.Truth.assertThat
import com.google.protobuf.ByteString
import com.signify.hue.flutterreactiveble.ble.BleClient
import io.flutter.plugin.common.EventChannel
import io.mockk.MockKAnnotations
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.verify
import io.reactivex.Observable
import io.reactivex.android.plugins.RxAndroidPlugins
import io.reactivex.schedulers.Schedulers
import io.reactivex.subjects.PublishSubject
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import java.nio.ByteBuffer
import java.util.UUID
import com.signify.hue.flutterreactiveble.ProtobufModel as pb

class CharNotificationHandlerTest {
    @MockK
    private lateinit var bleClient: BleClient

    @MockK(relaxed = true)
    private lateinit var eventSink: EventChannel.EventSink

    private lateinit var sut: CharNotificationHandler

    @BeforeEach
    fun setup() {
        MockKAnnotations.init(this)
        RxAndroidPlugins.setMainThreadSchedulerHandler { Schedulers.trampoline() }
        RxAndroidPlugins.setInitMainThreadSchedulerHandler { Schedulers.trampoline() }
        sut = CharNotificationHandler(bleClient)
        sut.onListen(null, eventSink)
    }

    @AfterEach
    fun teardown() {
        sut.onCancel(null)
        RxAndroidPlugins.reset()
    }

    @Test
    fun `completes subscription only after setupNotification emits inner observable`() {
        val outerSubject = PublishSubject.create<Observable<ByteArray>>()
        val innerSubject = PublishSubject.create<ByteArray>()

        every { bleClient.setupNotification(any(), any(), any()) }.returns(outerSubject)

        val uuid = UUID.randomUUID()
        val uuidBytes =
            ByteBuffer.wrap(ByteArray(16))
                .putLong(uuid.mostSignificantBits)
                .putLong(uuid.leastSignificantBits)
                .array()

        val charAddress =
            pb.CharacteristicAddress.newBuilder()
                .setDeviceId("device1")
                .setServiceUuid(pb.Uuid.newBuilder().setData(ByteString.copyFrom(uuidBytes)))
                .setServiceInstanceId("10")
                .setCharacteristicUuid(pb.Uuid.newBuilder().setData(ByteString.copyFrom(uuidBytes)))
                .setCharacteristicInstanceId("11")
                .build()

        val request =
            pb.NotifyCharacteristicRequest.newBuilder()
                .setCharacteristic(charAddress)
                .build()

        var completed = false
        sut.subscribeToNotifications(
            request,
            onSubscriptionCompleted = {
                completed = true
            },
        )

        assertThat(completed).isFalse()

        outerSubject.onNext(innerSubject)
        assertThat(completed).isTrue()

        innerSubject.onNext(byteArrayOf(1, 2, 3))
        verify(exactly = 1) { eventSink.success(any()) }
    }

    @Test
    fun `reports subscription error if setupNotification fails before emitting inner observable`() {
        val outerSubject = PublishSubject.create<Observable<ByteArray>>()

        every { bleClient.setupNotification(any(), any(), any()) }.returns(outerSubject)

        val uuid = UUID.randomUUID()
        val uuidBytes =
            ByteBuffer.wrap(ByteArray(16))
                .putLong(uuid.mostSignificantBits)
                .putLong(uuid.leastSignificantBits)
                .array()

        val charAddress =
            pb.CharacteristicAddress.newBuilder()
                .setDeviceId("device1")
                .setServiceUuid(pb.Uuid.newBuilder().setData(ByteString.copyFrom(uuidBytes)))
                .setServiceInstanceId("10")
                .setCharacteristicUuid(pb.Uuid.newBuilder().setData(ByteString.copyFrom(uuidBytes)))
                .setCharacteristicInstanceId("11")
                .build()

        val request =
            pb.NotifyCharacteristicRequest.newBuilder()
                .setCharacteristic(charAddress)
                .build()

        var completed = false
        var receivedError: Throwable? = null
        sut.subscribeToNotifications(
            request,
            onSubscriptionCompleted = {
                completed = true
            },
            onSubscriptionError = { error ->
                receivedError = error
            },
        )

        val expectedError = IllegalStateException("Notification setup failed")
        outerSubject.onError(expectedError)

        assertThat(completed).isFalse()
        assertThat(receivedError).isEqualTo(expectedError)
    }
}
