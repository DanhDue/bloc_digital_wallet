// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Application-specific configuration
///
/// This contains app-level constants that are specific to this application
/// and should not be in the reusable `core` package.
class AppConfig {
  AppConfig._(); // Private constructor to prevent instantiation

  /// App display name
  static const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'D3NexusShield');

  /// App suffix for environment (dev, stg, prd)
  static const String appSuffix = String.fromEnvironment('APP_SUFFIX', defaultValue: 'dev');

  /// Full app display name with suffix
  static String get displayName => '$appName ($appSuffix)';
}
