// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'ssl_configuration.dart';

/// SSL pinning disabled — the request goes through Dio's default
/// [HttpClient], which validates the server certificate against the
/// platform's system trust store (the normal browser-grade behaviour).
///
/// Selected by [AutoSslConfiguration] in non-debug builds when
/// `ENABLE_SSL_PINNING` is false or no [SslFingerprintSource] is configured.
class NoSslPinning extends SslConfiguration {
  const NoSslPinning();

  @override
  void configure(Dio dio, Talker talker) {
    talker.debug('SSL Pinning: disabled (system trust store)');
    // Intentionally a no-op: no `createHttpClient` / `badCertificateCallback`
    // override — the default adapter already does system-CA validation.
  }
}
