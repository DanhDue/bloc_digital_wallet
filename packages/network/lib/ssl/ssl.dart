// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// SSL Configuration Strategies
//
// Available implementations:
// - DebugSslConfiguration - Accepts all certificates (dev only)
// - HardenedSslPinning    - Certificate fingerprint validation (needs an SslFingerprintSource)
// - NoSslPinning          - System trust store, no pinning
// - AutoSslConfiguration  - Build-mode + config aware selector (recommended)
//
// Fingerprint sources:
// - SslFingerprintSource   - interface, bound in the app's composition layer
// - StaticFingerprintSource - pure-Dart, fingerprints passed in directly
export 'auto_ssl_configuration.dart';
export 'debug_ssl_configuration.dart';
export 'hardened_ssl_pinning.dart';
export 'no_ssl_pinning.dart';
export 'ssl_configuration.dart';
export 'ssl_fingerprint_source.dart';
export 'static_fingerprint_source.dart';
