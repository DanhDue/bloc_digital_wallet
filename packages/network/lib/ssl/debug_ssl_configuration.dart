// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'ssl_configuration.dart';

/// Debug SSL Configuration - Allows self-signed certificates.
/// Only for development/testing environments.
///
/// [!CAUTION] This configuration accepts ALL certificates, bypassing SSL validation.
/// A runtime assertion prevents instantiation in release builds.
class DebugSslConfiguration extends SslConfiguration {
  DebugSslConfiguration() {
    assert(
      kDebugMode,
      'DebugSslConfiguration must only be used in debug mode. '
      'Using this in production would disable SSL certificate validation.',
    );
  }

  @override
  void configure(Dio dio, Talker talker) {
    if (kIsWeb) return;

    talker.debug('SSL Pinning: Debug mode (accepting all certificates)');
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
}
