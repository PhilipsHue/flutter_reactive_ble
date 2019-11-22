package com.signify.hue.flutterreactiveble.ble

import android.content.Context
import com.google.common.truth.Truth.assertThat
import com.polidea.rxandroidble2.RxBleClient
import com.polidea.rxandroidble2.RxBleConnection
import com.polidea.rxandroidble2.RxBleDevice
import com.signify.hue.flutterreactiveble.ble.extensions.writeCharWithResponse
import com.signify.hue.flutterreactiveble.ble.extensions.writeCharWithoutResponse
import com.signify.hue.flutterreactiveble.utils.Duration
import io.mockk.MockKAnnotations
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.mockkStatic
import io.mockk.verify
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.android.plugins.RxAndroidPlugins
import io.reactivex.schedulers.TestScheduler
import io.reactivex.subjects.BehaviorSubject
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.After
import org.junit.Before
import java.util.UUID
import java.util.concurrent.TimeUnit

private class BleClientForTesting(val bleClient: RxBleClient, appContext: Context, val deviceConnector: com.signify.hue.flutterreactiveble.ble.DeviceConnector) : com.signify.hue.flutterreactiveble.ble.ReactiveBleClient(appContext) {

    override fun initializeClient() {
        rxBleClient = bleClient
        activeConnections = mutableMapOf()
    }

    override fun createDeviceConnector(device: RxBleDevice, timeout: Duration): com.signify.hue.flutterreactiveble.ble.DeviceConnector = deviceConnector
}

@DisplayName("BleClient unit tests")
class ReactiveBleClientTest {

    @MockK
    private lateinit var context: Context

    @MockK
    private lateinit var rxBleClient: RxBleClient

    @MockK
    private lateinit var deviceConnector: com.signify.hue.flutterreactiveble.ble.DeviceConnector

    @MockK
    private lateinit var bleDevice: RxBleDevice

    @MockK
    lateinit var rxConnection: RxBleConnection

    private lateinit var subject: BehaviorSubject<com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult>

    private lateinit var sut: BleClientForTesting

    private val testTimeout = Duration(100L, TimeUnit.MILLISECONDS)

    private var testScheduler: TestScheduler? = null

    @Before
    fun before() {
        testScheduler = TestScheduler()
        // Set calls to AndroidSchedulers.mainThread() to use the test scheduler
        RxAndroidPlugins.setMainThreadSchedulerHandler { testScheduler }
    }

    @After
    fun after() {
        RxAndroidPlugins.reset()
    }

    @BeforeEach
    fun setup() {
        MockKAnnotations.init(this)
        mockkStatic("com.signify.hue.flutterreactiveble.ble.extensions.RxBleConnectionExtensionKt")
        subject = BehaviorSubject.create<com.signify.hue.flutterreactiveble.ble.EstablishConnectionResult>()

        sut = BleClientForTesting(rxBleClient, context, deviceConnector)
        sut.initializeClient()

        every { bleDevice.observeConnectionStateChanges() }.returns(Observable.just(RxBleConnection.RxBleConnectionState.CONNECTED))
        every { rxBleClient.getBleDevice(any()) }.returns(bleDevice)
        every { deviceConnector.connection }.returns(subject)

        subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishedConnection("test", rxConnection))
    }

    @AfterEach
    fun teardown(){
        subject.onComplete()
    }


    @DisplayName("Establishing a connection")
    @Nested
    inner class EstablishConnectionTest{

        @Test
        fun `should use deviceconnector when connecting to a device` () {
            sut.connectToDevice("test", testTimeout)

            verify(exactly = 1) { deviceConnector.connection }
        }
    }

    @Nested
    @DisplayName ("Writing reading and subscribing to characteristics")
    inner class BleOperationsTest{
        @Test
        fun `should call readcharacteristic in case the connection is established`() {
            sut.readCharacteristic("test", UUID.randomUUID()).test()

            verify(exactly = 1) { rxConnection.readCharacteristic(any<UUID>()) }
        }

        @Test
        fun `should not call readcharacteristic in case the connection is not established`() {
            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))

            sut.readCharacteristic("test", UUID.randomUUID()).test()

            verify(exactly = 0) { rxConnection.readCharacteristic(any<UUID>()) }
        }

        @Test
        fun `should report failure in case reading characteristic fails`() {
            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))

            val observable = sut.readCharacteristic("test", UUID.randomUUID()).test()

            assertThat(observable.values().first()).isInstanceOf(com.signify.hue.flutterreactiveble.ble.CharOperationFailed::class.java)
        }

        @Test
        fun `should incorporate the value in case readcharacteristics succeeds`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE

            every { rxConnection.readCharacteristic(any<UUID>()) }.returns(Single.just(byteArrayOf(byteMin, byteMax)))
            val observable = sut.readCharacteristic("test", UUID.randomUUID())
                    .map { result -> result as com.signify.hue.flutterreactiveble.ble.CharOperationSuccessful }.test()

            assertThat(observable.values().first().value).isEqualTo(listOf(byteMin, byteMax))
        }

        @Test
        fun `should call writecharacteristicResponse in case the connection is established`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)

            sut.writeCharacteristicWithResponse("test", UUID.randomUUID(), bytes).test()

            verify(exactly = 1) { rxConnection.writeCharWithResponse(any<UUID>(), any()) }
        }

        @Test
        fun `should not call writecharacteristicWithoutResponse in case the connection is established`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)

            sut.writeCharacteristicWithResponse("test", UUID.randomUUID(), bytes).test()

            verify(exactly = 0) { rxConnection.writeCharWithoutResponse(any<UUID>(), any()) }
        }

        @Test
        fun `should not call writecharacteristicResponse in case the connection is not established`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)
            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))

            sut.writeCharacteristicWithResponse("test", UUID.randomUUID(), bytes).test()

            verify(exactly = 0) { rxConnection.writeCharWithResponse(any<UUID>(), any()) }
        }

        @Test
        fun `should call writecharacteristicWithoutResponse in case the connection is established`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)

            sut.writeCharacteristicWithoutResponse("test", UUID.randomUUID(), bytes).test()

            verify(exactly = 1) { rxConnection.writeCharWithoutResponse(any<UUID>(), any()) }
        }

        @Test
        fun `should not call writecharacteristicWithoutResponse in case the connection is not established`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)
            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))


            sut.writeCharacteristicWithoutResponse("test", UUID.randomUUID(), bytes).test()

            verify(exactly = 0) { rxConnection.writeCharWithoutResponse(any<UUID>(), any()) }
        }

        @Test
        fun `should report failure in case writing characteristic fails`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)

            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))

            val observable = sut.writeCharacteristicWithResponse("test", UUID.randomUUID(), bytes).test()

            assertThat(observable.values().first()).isInstanceOf(com.signify.hue.flutterreactiveble.ble.CharOperationFailed::class.java)
        }

        @Test
        fun `should incorporate the value in case writecharacteristic succeeds`() {
            val byteMin = Byte.MIN_VALUE
            val byteMax = Byte.MAX_VALUE
            val bytes = byteArrayOf(byteMin, byteMax)

            every { rxConnection.writeCharWithResponse(any(), any()) }.returns(Single.just(byteArrayOf(byteMin, byteMax)))
            val observable = sut.writeCharacteristicWithResponse("test", UUID.randomUUID(), bytes)
                    .map { result -> result as com.signify.hue.flutterreactiveble.ble.CharOperationSuccessful }.test()

            assertThat(observable.values().first().value).isEqualTo(bytes.toList())
        }
    }

    @Nested
    @DisplayName("Negotiate mtu")
    inner class NegotiateMtuTest{

        @Test
        fun `should return mtunegotiatesuccesful in case it succeeds` (){
            val mtuSize = 19
            every { rxConnection.requestMtu(any()) }.returns(Single.just(mtuSize))

            val result = sut.negotiateMtuSize("", mtuSize).test()

            assertThat(result.values().first()).isInstanceOf(com.signify.hue.flutterreactiveble.ble.MtuNegotiateSuccesful::class.java)
        }

        @Test
        fun `should return mtunegotiatefailed in case it fails` (){
            val mtuSize = 19
            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))

            val result = sut.negotiateMtuSize("", mtuSize).test()

            assertThat(result.values().first()).isInstanceOf(com.signify.hue.flutterreactiveble.ble.MtuNegotiateFailed::class.java)
        }
    }

    @Nested
    @DisplayName("Observe status")
    inner class ObserveBleStatusTest{
        private val currentStatus = RxBleClient.State.BLUETOOTH_NOT_ENABLED
        private val changedStatus = RxBleClient.State.READY

        @BeforeEach
        fun setup(){
            every { rxBleClient.observeStateChanges() }.returns(Observable.just(changedStatus))
            every { rxBleClient.state }.returns(currentStatus)
        }

        @Test
        fun `observes status changes` (){
            val result = sut.observeBleStatus().test()

            assertThat(result.values().last()).isEqualTo(com.signify.hue.flutterreactiveble.ble.BleStatus.READY)
            assertThat(result.values().count()).isEqualTo(2)
        }

        @Test
        fun `starts with current state` (){

            val result = sut.observeBleStatus().test()
            assertThat(result.values().count()).isEqualTo(2)
            assertThat(result.values().first()).isEqualTo(com.signify.hue.flutterreactiveble.ble.BleStatus.POWERED_OFF)
        }
    }

    @Nested
    @DisplayName("Change priority")
    inner class ChangePriorityTest{

        @Test
        fun `returns prioritysuccess when  completed` () {
            val completer = Completable.fromCallable { true }

            every{rxConnection.requestConnectionPriority(any(), any(), any())}.returns(completer)
            val result = sut.requestConnectionPriority("", com.signify.hue.flutterreactiveble.ble.ConnectionPriority.BALANCED).test()
            assertThat(result.values().first()).isInstanceOf(com.signify.hue.flutterreactiveble.ble.RequestConnectionPrioritySuccess::class.java)
        }

        @Test
        fun `returns false when connectionfailed` () {
            subject.onNext(com.signify.hue.flutterreactiveble.ble.EstablishConnectionFailure("test", "error"))
            val result = sut.requestConnectionPriority("", com.signify.hue.flutterreactiveble.ble.ConnectionPriority.BALANCED).test()
            assertThat(result.values().first()).isInstanceOf(com.signify.hue.flutterreactiveble.ble.RequestConnectionPriorityFailed::class.java)
        }
    }

}
