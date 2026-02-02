// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'ssl_configuration.dart';

/// No SSL Pinning - Uses default platform SSL validation.
/// Suitable for projects that don't require certificate pinning.
class NoSslPinning extends SslConfiguration {
  const NoSslPinning();

  @override
  void configure(Dio dio, Talker talker) {
    // No-op: uses default platform SSL validation
    talker.debug('SSL Pinning: Disabled (using platform defaults)');
  }
}
