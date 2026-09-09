// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'debug_ssl_configuration.dart';
import 'hardened_ssl_pinning.dart';
import 'no_ssl_pinning.dart';
import 'ssl_configuration.dart';
import 'ssl_fingerprint_source.dart';

/// Build-mode + config aware SSL strategy selector.
///
/// - **Debug** builds always use [DebugSslConfiguration] (accept every
///   certificate) — pinning against localhost / self-signed dev servers is not
///   useful.
/// - **Non-debug** builds use [HardenedSslPinning] when pinning is enabled
///   (`EnvironmentConfig.enableSslPinning`, overridable via [pinningEnabled])
///   **and** a [source] is provided; otherwise [NoSslPinning] (system trust).
///
/// `packages/network` registers `const AutoSslConfiguration()` (no [source]) as
/// its default, so a bare template does no pinning. The app overrides it with a
/// real [SslFingerprintSource] in its composition layer.
class AutoSslConfiguration extends SslConfiguration {
  const AutoSslConfiguration({this.source, bool? pinningEnabled})
    : _pinningEnabled = pinningEnabled;

  /// Where [HardenedSslPinning] reads fingerprints from. `null` ⇒ pinning is
  /// impossible, so non-debug builds fall back to [NoSslPinning].
  final SslFingerprintSource? source;

  final bool? _pinningEnabled;

  /// Whether pinning should run in non-debug builds. Defaults to
  /// `EnvironmentConfig.enableSslPinning` (`ENABLE_SSL_PINNING` dart-define).
  bool get pinningEnabled => _pinningEnabled ?? EnvironmentConfig.enableSslPinning;

  /// The strategy chosen for non-debug builds. Split out because `kDebugMode`
  /// is always `true` under `flutter test`, so [configure] can't be exercised
  /// on this path directly.
  static SslConfiguration releaseStrategy({
    required bool pinningEnabled,
    SslFingerprintSource? source,
  }) {
    if (pinningEnabled && source != null) {
      return HardenedSslPinning(source: source);
    }
    return const NoSslPinning();
  }

  @override
  void configure(Dio dio, Talker talker) {
    if (kDebugMode) {
      DebugSslConfiguration().configure(dio, talker);
      return;
    }
    releaseStrategy(pinningEnabled: pinningEnabled, source: source).configure(dio, talker);
  }
}
