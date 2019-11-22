package com.signify.hue.flutterreactiveble.channelhandlers
import com.google.common.truth.Truth.assertThat
import io.reactivex.subjects.BehaviorSubject
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.BeforeEach

class ConnectionQueueTest {

    private lateinit var sut: com.signify.hue.flutterreactiveble.ble.ConnectionQueue

    @BeforeEach
    fun setup() {
        sut = com.signify.hue.flutterreactiveble.ble.ConnectionQueue()
    }

    @Test
    fun `should be able to add an item to the queue`() {
        sut.addToQueue("test")
        assertThat(sut.getCurrentQueue()?.size).isEqualTo(1)
    }

    @Test
    fun `should not be able to add an item to the queue twice`() {
        sut.addToQueue("test")
        sut.addToQueue("test")
        assertThat(sut.getCurrentQueue()?.size).isEqualTo(1)
    }

    @Test
    fun `should be able to see all devices in the queue`() {
        sut.addToQueue("device1")
        sut.addToQueue("device2")
        sut.addToQueue("device3")
        assertThat(sut.getCurrentQueue()?.size).isEqualTo(3)
    }

    @Test
    fun `should be able to remove an item to the queue`() {
        sut.addToQueue("test")
        sut.removeFromQueue("test")
        assertThat(sut.getCurrentQueue()?.size).isEqualTo(0)
    }

    @Test
    fun `should provide behavior subject for observing latest queue state`() {
        assertThat(sut.observeQueue()).isInstanceOf(BehaviorSubject::class.java)
    }

    @Test
    fun `should return an emptylist when queue is created`() {
        assertThat(sut.observeQueue().test().values().first().size).isEqualTo(0)
    }

    @Test
    fun `should provide me new queue each time something changed`() {
        val observable = sut.observeQueue().test()
        sut.addToQueue("test")

        assertThat(observable.valueCount()).isEqualTo(2)
    }

    @Test
    fun `should be ordened in the sequence of adding`() {
        val expectedQueue = listOf("test1", "test2")
        val observable = sut.observeQueue().test()
        sut.addToQueue("test1")
        sut.addToQueue("test2")

        val lastQueue = observable.values().last()
        assertThat(lastQueue).isEqualTo(expectedQueue)
    }

    @Test
    fun `should update queue after removal`() {
        val observable = sut.observeQueue().test()
        sut.addToQueue("test1")
        sut.addToQueue("test2")
        sut.removeFromQueue("test2")

        assertThat(observable.valueCount()).isEqualTo(4)
    }
}
