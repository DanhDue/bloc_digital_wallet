// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:native_security/native_security.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'ssl_configuration.dart';

/// Hardened SSL Pinning - Uses native fingerprints from FFI.
/// For production environments requiring certificate pinning.
class HardenedSslPinning extends SslConfiguration {
  const HardenedSslPinning();

  @override
  void configure(Dio dio, Talker talker) {
    if (kIsWeb) return;

    talker.debug('SSL Pinning: Hardened mode with certificate fingerprint validation');

    // Load fingerprints once at configuration time (not per-handshake)
    List<String> hardenedFingerprints = [];
    try {
      hardenedFingerprints = NativeSecurity.getAllowedFingerprints();
      talker.debug('Hardened fingerprints loaded: ${hardenedFingerprints.length} entries');
    } catch (e) {
      talker.error('Failed to load hardened fingerprints via FFI', e);
      // Continue with empty list - all certs will fail validation
    }

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      // withTrustedRoots: false ensures that NO system-trusted CAs are used.
      // This forces badCertificateCallback to be called for ALL certificates,
      // allowing us to manually validate even "valid" CA-signed certificates.
      final client = HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Calculate the SHA-256 digest of the DER-encoded certificate
        final hash = sha256.convert(cert.der);

        // Encode to Base64 to match standard fingerprint formats
        final fingerprint = base64.encode(hash.bytes);

        // Only log fingerprint details in debug builds
        assert(() {
          talker.debug('Handshake fingerprint: $fingerprint');
          return true;
        }());

        final isValid = hardenedFingerprints.contains(fingerprint);
        if (!isValid) {
          talker.warning('SSL Pinning failed for $host. Fingerprint mismatch.');
        }
        return isValid;
      };
      return client;
    };
  }
}
