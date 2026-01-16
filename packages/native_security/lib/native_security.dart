// Copyright (c) 2025, one of the DanhDue ExOICTIF projects. All rights reserved.

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Definition of the C function signatures
typedef GetSslPinC = Pointer<Utf8> Function();
typedef GetSslPinDart = Pointer<Utf8> Function();

class NativeSecurity {
  static final DynamicLibrary _nativeLib = _loadLibrary();

  static DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      try {
        return DynamicLibrary.open('libnative_security.so');
      } catch (e) {
        throw UnsupportedError('Android FFI load failed: $e');
      }
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final List<String> errors = [];

      // 1. Try executable (Primary for static_framework: true)
      try {
        final lib = DynamicLibrary.executable();
        lib.lookup('get_ssl_pin_1');
        return lib;
      } catch (e) {
        errors.add('executable: $e');
      }

      // 2. Try process
      try {
        final lib = DynamicLibrary.process();
        lib.lookup('get_ssl_pin_1');
        return lib;
      } catch (e) {
        errors.add('process: $e');
      }

      // 3. Fallback for dynamic frameworks
      final List<String> paths = [
        'native_security.framework/native_security',
        'NativeSecurity.framework/NativeSecurity',
        'Frameworks/native_security.framework/native_security',
        'Frameworks/NativeSecurity.framework/NativeSecurity',
      ];

      for (final path in paths) {
        try {
          final lib = DynamicLibrary.open(path);
          lib.lookup('get_ssl_pin_1');
          return lib;
        } catch (e) {
          errors.add('$path: $e');
        }
      }

      throw UnsupportedError(
          'iOS FFI load failed. Please run "flutter pub get" and "cd ios && pod install".\n'
          'Detailed errors:\n${errors.join("\n")}\n'
          'If this persists, check if the plugin is correctly registered in Xcode.');
    }
    throw UnsupportedError('Platform not supported for NativeSecurity');
  }

  static String getSslPin1() {
    try {
      final getPin = _nativeLib.lookupFunction<GetSslPinC, GetSslPinDart>('get_ssl_pin_1');
      final ptr = getPin();
      return ptr.toDartString();
    } catch (e) {
      throw UnsupportedError('FFI lookup failed for get_ssl_pin_1: $e');
    }
  }

  static String getSslPin2() {
    try {
      final getPin = _nativeLib.lookupFunction<GetSslPinC, GetSslPinDart>('get_ssl_pin_2');
      final ptr = getPin();
      return ptr.toDartString();
    } catch (e) {
      throw UnsupportedError('FFI lookup failed for get_ssl_pin_2: $e');
    }
  }

  static String getSslPin3() {
    try {
      final getPin = _nativeLib.lookupFunction<GetSslPinC, GetSslPinDart>('get_ssl_pin_3');
      final ptr = getPin();
      return ptr.toDartString();
    } catch (e) {
      throw UnsupportedError('FFI lookup failed for get_ssl_pin_3: $e');
    }
  }

  /// Returns both hardened fingerprints.
  static List<String> getAllowedFingerprints() {
    return [getSslPin1(), getSslPin2(), getSslPin3()];
  }
}
