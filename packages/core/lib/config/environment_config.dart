// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/logger.dart';

/// Environment Configuration
///
/// Reads environment variables from --dart-define-from-file
/// Usage: EnvironmentConfig.apiBaseUrl, EnvironmentConfig.enableLogging, etc.
class EnvironmentConfig {
  EnvironmentConfig._();

  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  /// Environment name (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// API Base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://danhdue.com',
  );

  /// API Version
  static const String apiVersion = String.fromEnvironment('API_VERSION', defaultValue: 'v1');

  /// Enable logging
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);

  /// Enable analytics
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  /// Show debug banner
  static const bool showDebugBanner = bool.fromEnvironment(
    'SHOW_DEBUG_BANNER',
    defaultValue: true,
  );

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';

  /// Check if running in staging
  static bool get isStaging => environment == 'staging';

  /// Check if running in production
  static bool get isProduction => environment == 'production';

  /// Get full API URL
  static String get fullApiUrl {
    final base = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;
    final version = apiVersion.startsWith('/') ? apiVersion.substring(1) : apiVersion;
    return version.isEmpty ? base : '$base/$version';
  }

  /// Print all environment configurations (for debugging)
  static void printConfig() {
    if (!enableLogging) return;

    _logger.i('''
═══════════════════════════════════════════
🔧 Environment Configuration
═══════════════════════════════════════════
Environment: $environment
API Base URL: $apiBaseUrl
API Version: $apiVersion
Full API URL: $fullApiUrl
Enable Logging: $enableLogging
Enable Analytics: $enableAnalytics
Show Debug Banner: $showDebugBanner
Is Development: $isDevelopment
Is Staging: $isStaging
Is Production: $isProduction
═══════════════════════════════════════════
''');
  }
}
