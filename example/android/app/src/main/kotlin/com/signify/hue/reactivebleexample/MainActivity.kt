package com.signify.hue.reactivebleexample


import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import android.os.Bundle
import com.polidea.rxandroidble2.exceptions.BleException
import io.reactivex.exceptions.UndeliverableException
import io.reactivex.plugins.RxJavaPlugins


class MainActivity: FlutterActivity(){
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    RxJavaPlugins.setErrorHandler { throwable ->
      if (throwable is UndeliverableException && throwable.cause is BleException) {
        return@setErrorHandler // ignore BleExceptions since we do not have subscriber
      } else {
        throw throwable
      }
        // fix for rxjava undelivered exception see:
        // https://github.com/Polidea/RxAndroidBle/wiki/FAQ:-UndeliverableException
        RxJavaPlugins.setErrorHandler { error ->
            if (error is UndeliverableException) {
                return@setErrorHandler
            } else {
                throw error
            }
        }
  }
}
