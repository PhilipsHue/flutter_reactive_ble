package com.signify.hue.flutterreactiveble

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class ReactiveBlePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        initializePlugin(binding.binaryMessenger, binding.applicationContext, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        deinitializePlugin()
    }

    companion object {
        lateinit var pluginController: PluginController

        @JvmStatic
        private fun initializePlugin(
            messenger: BinaryMessenger,
            context: Context,
            plugin: ReactiveBlePlugin,
        ) {
            val channel = MethodChannel(messenger, "flutter_reactive_ble_method")
            channel.setMethodCallHandler(plugin)
            pluginController = PluginController()
            pluginController.initialize(messenger, context)
        }

        @JvmStatic
        private fun deinitializePlugin() {
            pluginController.deinitialize()
        }
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result,
    ) {
        pluginController.execute(call, result)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(pluginController)
        pluginController.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        pluginController.setActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(pluginController)
        pluginController.setActivity(binding.activity)
    }

    override fun onDetachedFromActivity() {
        pluginController.setActivity(null)
    }
}
