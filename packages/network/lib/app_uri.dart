// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Infrastructure-level URI constants used by the network package itself.
/// Feature-specific URIs should be defined in each module's own URI class
/// (e.g., `WalletUri`, `ScannerUri`) at `data/datasources/remote/{name}_uri.dart`.
class AppUri {
  // Used by auth_interceptor.dart for path matching
  static const String login = 'login';
  static const String register = 'register';

  // Used by string_ext.dart for health check special handling
  static const String healthz = 'healthz';
}

class UriPaths {
  static const String api = "api";
  static const String apiVersion = "v1";
}
