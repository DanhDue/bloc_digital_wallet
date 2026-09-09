// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'ssl_configuration.dart';
import 'ssl_fingerprint_source.dart';

/// Hardened certificate pinning: the leaf certificate presented in the TLS
/// handshake must match a fingerprint from [source] for the target host, or the
/// connection is refused.
///
/// The fingerprint source is injected — `packages/network` no longer depends on
/// `packages/native_security`. The app binds a concrete source (FFI-backed,
/// static, remote, …) in its composition layer, and a different backend can be
/// given its own `HardenedSslPinning(source: …)` (or [NoSslPinning]).
class HardenedSslPinning extends SslConfiguration {
  const HardenedSslPinning({required this.source});

  final SslFingerprintSource source;

  /// base64(sha256(cert.der)) — the fingerprint form [SslFingerprintSource]
  /// entries are compared against.
  static String fingerprintOf(X509Certificate cert) =>
      base64.encode(sha256.convert(cert.der).bytes);

  /// True iff [cert]'s fingerprint is one [source] allows for [host]. An empty
  /// allow-list is fail-closed. Pure — exercised directly in tests; also the
  /// body of the `badCertificateCallback` [configure] installs.
  bool accepts(X509Certificate cert, String host, {Talker? talker}) {
    final allowed = source.fingerprintsFor(host);
    if (allowed.isEmpty) {
      talker?.warning('SSL Pinning: no fingerprints configured for $host — rejecting');
      return false;
    }
    final fingerprint = fingerprintOf(cert);
    final ok = allowed.contains(fingerprint);
    if (!ok) {
      talker?.warning('SSL Pinning failed for $host — fingerprint mismatch');
    }
    return ok;
  }

  @override
  void configure(Dio dio, Talker talker) {
    if (kIsWeb) return;

    talker.debug('SSL Pinning: hardened mode (certificate fingerprint validation)');

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      // withTrustedRoots: false ⇒ badCertificateCallback fires for EVERY
      // certificate, so even a CA-valid cert is only accepted when its
      // fingerprint is one we pinned.
      final client = HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = (X509Certificate cert, String host, int port) =>
          accepts(cert, host, talker: talker);
      return client;
    };
  }
}
