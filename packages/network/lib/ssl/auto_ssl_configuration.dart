// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'debug_ssl_configuration.dart';
import 'hardened_ssl_pinning.dart';
import 'ssl_configuration.dart';

/// Auto SSL Configuration - Automatically selects based on build mode.
/// - Debug mode: Uses DebugSslConfiguration
/// - Release mode: Uses HardenedSslPinning
class AutoSslConfiguration extends SslConfiguration {
  const AutoSslConfiguration();

  @override
  void configure(Dio dio, Talker talker) {
    if (kDebugMode) {
      DebugSslConfiguration().configure(dio, talker);
    } else {
      const HardenedSslPinning().configure(dio, talker);
    }
  }
}
