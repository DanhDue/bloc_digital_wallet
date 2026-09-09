// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Supplies the certificate fingerprints [HardenedSslPinning] validates against.
///
/// `packages/network` defines only this interface and the pure-Dart
/// [StaticFingerprintSource]. The concrete, platform-specific source (e.g. the
/// FFI-backed one wrapping `packages/native_security`) is bound in the app's
/// composition layer, so `network` stays free of any native dependency and the
/// source can be swapped per backend.
abstract interface class SslFingerprintSource {
  /// SHA-256 digests of the leaf certificates accepted for [host], each
  /// **base64-encoded** (`base64(sha256(cert.der))`).
  ///
  /// An empty list means "no pin configured for this host" — a pinning
  /// strategy treats that as fail-closed (reject).
  List<String> fingerprintsFor(String host);
}
