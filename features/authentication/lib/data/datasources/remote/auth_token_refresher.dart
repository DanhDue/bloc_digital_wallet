// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'auth_client.dart';
import 'package:injectable/injectable.dart';

/// Adapter that wraps [AuthClient] and implements [TokenRefresher] interface.
///
/// This follows the Dependency Inversion Principle:
/// - Core layer (AuthInterceptor) depends on [TokenRefresher] abstraction
/// - Feature layer provides this implementation
@LazySingleton(as: TokenRefresher)
class AuthTokenRefresher implements TokenRefresher {
  final AuthClient _authClient;

  AuthTokenRefresher(this._authClient);

  @override
  Future<TokenRefreshResult> refreshTokens({required String refreshToken}) async {
    final result = await _authClient.refreshToken(refresh: refreshToken);
    return TokenRefreshResult(accessToken: result.access, refreshToken: result.refresh);
  }
}
