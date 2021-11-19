package com.signify.hue.flutterreactiveble

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class ReactiveBlePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        initalizePlugin(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // deinitalize logic
    }

    companion object {
        lateinit var pluginController: PluginController
        @JvmStatic
        private fun initalizePlugin(messenger: BinaryMessenger, context: Context) {
            val channel = MethodChannel(messenger, "flutter_reactive_ble_method")
            channel.setMethodCallHandler(ReactiveBlePlugin())
            pluginController = PluginController()
            pluginController.initialize(messenger, context)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        pluginController.execute(call, result)
    }
}
