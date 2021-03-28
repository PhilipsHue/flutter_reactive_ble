package com.signify.hue.flutterreactiveble.ble

import com.google.common.truth.Truth.assertThat
import com.polidea.rxandroidble2.RxBleConnection
import com.polidea.rxandroidble2.RxBleDevice
import com.signify.hue.flutterreactiveble.model.ConnectionState
import com.signify.hue.flutterreactiveble.utils.Duration
import io.mockk.MockKAnnotations
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.verify
import io.mockk.verifySequence
import io.reactivex.Observable
import io.reactivex.subjects.BehaviorSubject
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import java.lang.Exception
import java.util.concurrent.TimeUnit

@DisplayName("DeviceConnector unit tests")


class DeviceConnectorTest {

    @MockK
    private lateinit var connection: RxBleConnection

    @MockK
    private lateinit var device: RxBleDevice

    @MockK
    private lateinit var connectionQueue: ConnectionQueue

    @MockK
    private  lateinit var updateListener: (update: ConnectionUpdate) -> Unit

    private lateinit var sut: DeviceConnector
    private lateinit var subject: BehaviorSubject<List<String>>
    private val deviceId = "123"

    @BeforeEach
    fun setup() {
        MockKAnnotations.init(this)
        subject = BehaviorSubject.create()
        every { device.connectionState }.returns(RxBleConnection.RxBleConnectionState.DISCONNECTED)
        every { device.observeConnectionStateChanges()}.returns(Observable.just(RxBleConnection.RxBleConnectionState.CONNECTED))
        every { device.macAddress }.returns(deviceId)
        every { updateListener.invoke(allAny()) }.returns(Unit)

        every {connectionQueue.addToQueue(any())}.returns(Unit)
        every {connectionQueue.observeQueue()}.returns(subject)
        every {connectionQueue.removeFromQueue(any())}.returns(Unit)

        subject.onNext(listOf(device.macAddress))
        sut = DeviceConnector(device, Duration(0L, TimeUnit.MILLISECONDS), updateListener, connectionQueue)

    }

    @AfterEach
    fun teardown(){
        sut.disconnectDevice(deviceId)
    }

    @Nested
    @DisplayName ("Successfull connection")
    inner class SuccesfullConnectionTest {

        @BeforeEach
        fun setup() {
            every { device.establishConnection(any()) }.returns(Observable.just(connection))
        }

        @Test
        @DisplayName("Add device to queue")
        fun addDeviceToQueue(){
            sut.connection.test()
            verify(exactly = 1) { connectionQueue.addToQueue(deviceId) }
        }


        @Test
        @DisplayName("Connects to device only once")
        fun connectOnlyOnce() {
            sut.connection.test()

            verify(exactly = 1) { device.establishConnection(allAny()) }
        }

        @Test
        @DisplayName("Does not connect when device is not in queue")
        fun doNotConnectWhenInQueue() {
            subject.onNext(listOf("Otherdevice", device.macAddress))
            sut.connection.test()

            verify(exactly = 0) { device.establishConnection(allAny()) }
        }

        @Test
        @DisplayName("Updates listeners in case of succesfull connection")
        fun updatesWhenSuccess() {
            sut.connection.test()

            verify(exactly = 1) { updateListener.invoke(ConnectionUpdateSuccess(deviceId, ConnectionState.CONNECTED.code)) }

        }

        @Test
        @DisplayName("Connects to device only once in casealready connected")
        fun connectOnlyOnceAlreadyConnected() {
            sut.connection.test()
            every { device.connectionState }.returns(RxBleConnection.RxBleConnectionState.CONNECTED)

            sut.connection.test()

            verify(exactly = 1) { device.establishConnection(allAny()) }
        }

        @Test
        @DisplayName("Remove device from queue")
        fun removeDeviceFromQueue(){
            sut.connection.test()
            verify(exactly = 1) { connectionQueue.removeFromQueue(deviceId) }
        }
    }


    @Nested
    @DisplayName ("Failed connection")
    inner class NotSuccesfullConnectionTest {
        private val errorMessage = "aaa"

        @BeforeEach
        fun setup() {
            every { device.establishConnection(any()) }.returns(Observable.error(Exception(errorMessage)))
        }

        @Test
        @DisplayName("Returns connection failed when connecting failed")
        fun failedToConnect() {
            val observer = sut.connection.test()

            assertThat(observer.values().first()).isInstanceOf(EstablishConnectionFailure::class.java)
        }

        @Test
        @DisplayName("Updates listeners in case of failed connection")
        fun updatesWhenFailed() {
            sut.connection.test()

            verify(exactly = 1) { updateListener.invoke(ConnectionUpdateError(deviceId, errorMessage)) }
        }

        @Test
        @DisplayName("Remove device from queue")
        fun removeDeviceFromQueue(){
            sut.connection.test()
            verify(exactly = 1) { connectionQueue.removeFromQueue(deviceId) }
        }
    }

    @Test
    @DisplayName("Dispose observable in case disconnecting")
    fun disposeOnDisconnect() {
        every { device.connectionState }.returns(RxBleConnection.RxBleConnectionState.DISCONNECTED)

        sut.connection.test()

        sut.disconnectDevice(deviceId)

        assertThat(sut.connectionDisposable?.isDisposed).isTrue()

        verify(exactly = 1) { updateListener.invoke(ConnectionUpdateSuccess(deviceId, ConnectionState.DISCONNECTED.code)) }
    }
}

