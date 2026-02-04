// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SecureClipboard {
  // Define a private MethodChannel
  // WARNING: Requires native implementation in MainActivity (Android) and AppDelegate (iOS)
  static const MethodChannel _platform = MethodChannel('com.zeno.app/clipboard');

  /// Copies text to the clipboard with security features.
  ///
  /// [text] The sensitive data (e.g. OTP, Seed Phrase).
  /// [expirySeconds] How long the data should live (default 30s).
  static Future<void> copySensitive({required String text, int expirySeconds = 30}) async {
    try {
      if (Platform.isIOS) {
        // iOS: The system handles auto-deletion even if app is killed.
        await _platform.invokeMethod('copySensitive', {'text': text, 'expiry': expirySeconds});
      } else if (Platform.isAndroid) {
        // Android: Mark as sensitive (hides from history/cloud) + Manual clear timer
        await _platform.invokeMethod('copySensitive', {'text': text});

        // "Best Effort" clearing for Android if app stays alive
        Timer(Duration(seconds: expirySeconds), () {
          _clearIfMatches(text);
        });
      }
    } on PlatformException catch (e) {
      // Log this to your Crashlytics/Logger
      debugPrint("SecureClipboard Error: ${e.message}");
      // Fallback to standard clipboard in case of native error
      await Clipboard.setData(ClipboardData(text: text));
      Timer(Duration(seconds: expirySeconds), () {
        _clearIfMatches(text);
      });
    } on MissingPluginException catch (_) {
      // Fallback for tests or if native not ready
      await Clipboard.setData(ClipboardData(text: text));
      Timer(Duration(seconds: expirySeconds), () {
        _clearIfMatches(text);
      });
    }
  }

  /// Checks if the clipboard still contains our secret and clears it.
  /// This prevents clearing the user's *new* copy if they copied something else.
  static Future<void> _clearIfMatches(String originalText) async {
    final currentData = await Clipboard.getData(Clipboard.kTextPlain);
    if (currentData?.text == originalText) {
      await Clipboard.setData(const ClipboardData(text: ''));
    }
  }
}
