// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

class AppUri {
  // Service names (path prefixes)
  static const String auth = 'auth';
  static const String users = 'users';
  static const String wallets = 'wallets';
  static const String tokens = 'tokens';
  static const String transactions = 'transactions';
  static const String markets = 'markets';
  static const String healthz = 'healthz';
}

class UriPaths {
  static const String api = "api";
  static const String apiVersion = "v1";
}

class UriPathParameters {
  static const String address = "/{address}";
  static const String signature = "/{signature}";
  static const String id = "/{id}";
}
