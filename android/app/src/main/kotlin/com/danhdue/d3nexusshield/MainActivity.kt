package com.danhdue.d3nexusshield

import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val clipboardChannel = "com.zeno.app/clipboard"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, clipboardChannel).setMethodCallHandler { call, result ->
            if (call.method == "copySensitive") {
                val text = call.argument<String>("text")
                if (text != null) {
                    copyToClipboardSensitive(text)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGS", "Text is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun copyToClipboardSensitive(text: String) {
        val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("Sensitive Info", text)

        // API 33+ (Android 13) allows marking content as sensitive
        // This hides it from the clipboard editor overlay and prevents remote sync
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            clip.description.extras = PersistableBundle().apply {
                putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, true)
            }
        } else {
            // For older Androids, we can add a custom sensitive flag
            // though the OS won't enforce it, some custom keyboards might respect it.
            val extras = PersistableBundle()
            extras.putBoolean("android.content.extra.IS_SENSITIVE", true)
            clip.description.extras = extras
        }

        clipboard.setPrimaryClip(clip)
    }
}
