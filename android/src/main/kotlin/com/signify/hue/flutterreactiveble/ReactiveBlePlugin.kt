package com.signify.hue.flutterreactiveble

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import timber.log.Timber

class ReactiveBlePlugin : MethodChannel.MethodCallHandler {
    companion object {
        lateinit var pluginController: com.signify.hue.flutterreactiveble.PluginController

        @JvmStatic
        fun registerWith(registrar: Registrar) {

            if (com.signify.hue.flutterreactiveble.BuildConfig.DEBUG) {
                Timber.plant(Timber.DebugTree())
            }

            val channel = MethodChannel(registrar.messenger(), "flutter_reactive_ble_method")
            channel.setMethodCallHandler(com.signify.hue.flutterreactiveble.ReactiveBlePlugin())
            com.signify.hue.flutterreactiveble.ReactiveBlePlugin.Companion.pluginController = com.signify.hue.flutterreactiveble.PluginController()
            com.signify.hue.flutterreactiveble.ReactiveBlePlugin.Companion.pluginController.initialize(registrar)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        com.signify.hue.flutterreactiveble.ReactiveBlePlugin.Companion.pluginController.execute(call, result)
    }
}
