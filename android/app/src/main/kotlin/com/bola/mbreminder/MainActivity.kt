package com.bola.mbreminder

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private companion object {
        const val CHANNEL = "mb_reminder/share"
        const val GET_SHARED_TEXT = "getSharedText"
        const val SHARED_TEXT = "sharedText"
    }

    private var shareChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        shareChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    GET_SHARED_TEXT -> result.success(intent?.getStringExtra(Intent.EXTRA_TEXT))
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        if (intent.action == Intent.ACTION_SEND) {
            val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
            if (!sharedText.isNullOrBlank()) {
                shareChannel?.invokeMethod(SHARED_TEXT, sharedText)
            }
        }
    }

    override fun onDestroy() {
        shareChannel?.setMethodCallHandler(null)
        shareChannel = null
        super.onDestroy()
    }
}
