// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'ssl_fingerprint_source.dart';

/// A pure-Dart [SslFingerprintSource] — fingerprints passed in directly
/// (e.g. from `--dart-define`, remote config, or a hard-coded map). No native
/// code, so it works anywhere and needs no `packages/native_security`.
///
/// - [anyHost] applies to every host.
/// - [byHost] adds host-specific fingerprints on top of [anyHost].
class StaticFingerprintSource implements SslFingerprintSource {
  const StaticFingerprintSource({
    Map<String, List<String>> byHost = const {},
    List<String> anyHost = const [],
  }) : _byHost = byHost,
       _anyHost = anyHost;

  /// No fingerprints for any host — `packages/network`'s default, i.e. pinning
  /// is effectively off until the app supplies a real source.
  const StaticFingerprintSource.empty() : this();

  final Map<String, List<String>> _byHost;
  final List<String> _anyHost;

  /// True when this source carries no fingerprints at all.
  bool get isEmpty => _byHost.isEmpty && _anyHost.isEmpty;

  @override
  List<String> fingerprintsFor(String host) => <String>[..._anyHost, ...?_byHost[host]];
}
