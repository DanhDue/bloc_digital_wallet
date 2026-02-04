// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// SSL Configuration Strategy Interface
/// Allows different SSL pinning implementations to be injected.
abstract class SslConfiguration {
  const SslConfiguration();

  /// Apply SSL configuration to the Dio instance.
  void configure(Dio dio, Talker talker);
}
