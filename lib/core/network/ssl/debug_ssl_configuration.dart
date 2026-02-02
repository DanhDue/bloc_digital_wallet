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
class DebugSslConfiguration extends SslConfiguration {
  const DebugSslConfiguration();

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
