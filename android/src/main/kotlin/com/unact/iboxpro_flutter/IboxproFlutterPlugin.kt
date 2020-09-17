package com.unact.iboxpro_flutter

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

class IboxproFlutterPlugin: FlutterPlugin {
  private var methodChannel: MethodChannel? = null
  private var handler: IboxproFlutterHandlerImpl? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    setupIboxproFlutterChannel(binding.binaryMessenger, binding.applicationContext)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    teardownIboxproFlutterChannel()
  }

  private fun setupIboxproFlutterChannel(messenger: BinaryMessenger, context: Context) {
    methodChannel = MethodChannel(messenger, CHANNEL_ID)
    handler = IboxproFlutterHandlerImpl(context, methodChannel!!)
    methodChannel!!.setMethodCallHandler(handler)
  }

  private fun teardownIboxproFlutterChannel() {
    methodChannel!!.setMethodCallHandler(null)
    handler = null
    methodChannel = null
  }

  companion object {
    private const val CHANNEL_ID = "iboxpro_flutter"

    @Suppress("unused")
    fun registerWith(registrar: Registrar) {
      if (registrar.activity() == null) {
        // When a background flutter view tries to register the plugin, the registrar has no activity.
        // We stop the registration process as this plugin is foreground only.
        return
      }

      IboxproFlutterPlugin().setupIboxproFlutterChannel(registrar.messenger(), registrar.context())
    }
  }
}
