// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:native_security/native_security.dart';
import 'package:network/network.dart';

/// The **only** place the app binds SSL pinning to `packages/native_security`.
///
/// `packages/network` stays native-free: it defines `SslFingerprintSource` and
/// consumes whatever the composition layer registers. Swapping pinning to a
/// different backend/package means providing a different `SslFingerprintSource`
/// here — nothing in `network` changes.
///
/// `native_security` exposes host-agnostic fingerprints (the app's single API
/// backend), so [host] is ignored. FFI failures degrade to an empty list, which
/// [HardenedSslPinning] treats as fail-closed.
class NativeSecurityFingerprintSource implements SslFingerprintSource {
  const NativeSecurityFingerprintSource();

  @override
  List<String> fingerprintsFor(String host) {
    try {
      return NativeSecurity.getAllowedFingerprints();
    } catch (_) {
      return const <String>[];
    }
  }
}
