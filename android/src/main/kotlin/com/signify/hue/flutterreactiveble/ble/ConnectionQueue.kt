package com.signify.hue.flutterreactiveble.ble

import androidx.annotation.VisibleForTesting
import io.reactivex.subjects.BehaviorSubject

internal class ConnectionQueue {

    private val queueSubject = BehaviorSubject.createDefault(listOf<String>())

    fun observeQueue() = queueSubject

    fun addToQueue(deviceId: String) {
        if (queueSubject.value?.find { it == deviceId } == null) {
            queueSubject.value?.let { currentQueue ->
                val newQueue = currentQueue.toMutableList()
                newQueue.add(deviceId)
                queueSubject.onNext(newQueue)
            }
        }
    }

    @VisibleForTesting
    internal fun getCurrentQueue() = queueSubject.value

    fun removeFromQueue(deviceId: String) {
        queueSubject.value?.let { currentQueue ->
            val newQueue = currentQueue.toMutableList()
            newQueue.remove(deviceId)
            queueSubject.onNext(newQueue)
        }
    }
}
