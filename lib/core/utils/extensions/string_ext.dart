// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/config/environment_config.dart';
import '../../network/app_uri.dart';

extension StringExt on String? {
  /// Builds a full API URI from a service name
  /// Example: "auth".buildAppUri() -> "https://api.example.com/api/v1/auth"
  String? buildAppUri() {
    if (this == null || this!.trim().isEmpty) {
      return null;
    }

    try {
      // Handle special health check case if needed
      if (this?.contains(AppUri.healthz) == true) {
        return Uri.parse('${EnvironmentConfig.apiBaseUrl}/$this').toString();
      }

      // Construct full URI: BaseUrl / ApiPath / Version / ServiceName
      // Note: EnvironmentConfig.apiBaseUrl usually contains the scheme and host (e.g. https://dev-api.example.com)

      final baseUrl = EnvironmentConfig.apiBaseUrl;
      final apiPath = UriPaths.api;
      final version = UriPaths.apiVersion;

      // Remove trailing slash from base if present
      final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

      return "$cleanBase/$apiPath/$version/$this";
    } catch (e) {
      return null;
    }
  }
}
