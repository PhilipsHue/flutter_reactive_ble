package com.signify.hue.flutterreactiveble.channelhandlers

import com.signify.hue.flutterreactiveble.ble.BleClient
import io.flutter.plugin.common.EventChannel
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.disposables.SerialDisposable
import java.util.concurrent.TimeUnit
import com.signify.hue.flutterreactiveble.ProtobufModel as pb

class BleStatusHandler(private val bleClient: BleClient) : EventChannel.StreamHandler {

    companion object {
        private const val delayListenBleStatus = 500L
    }

    private val subscriptionDisposable = SerialDisposable()

    override fun onListen(arg: Any?, eventSink: EventChannel.EventSink?) {
        subscriptionDisposable.set(eventSink?.let(::listenToBleStatus))
    }

    override fun onCancel(arg: Any?) {
        subscriptionDisposable.set(null)
    }

    private fun listenToBleStatus(eventSink: EventChannel.EventSink): Disposable =
            Observable.timer(delayListenBleStatus, TimeUnit.MILLISECONDS)
                    .switchMap { bleClient.observeBleStatus() }
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe({ bleStatus ->
                        val message = pb.BleStatusInfo.newBuilder()
                                .setStatus(bleStatus.code)
                                .build()
                        eventSink.success(message.toByteArray())
                    }, { throwable ->
                        eventSink.error("ObserveBleStatusFailure", throwable.message, null)
                    })
}
