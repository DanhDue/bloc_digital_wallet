// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Interface for token refresh operations.
///
/// This interface enables Dependency Inversion:
/// - Core layer (AuthInterceptor) depends on this abstraction
/// - Feature layer (AuthClient) implements this interface
///
/// This decouples the network layer from authentication feature implementation.
abstract interface class TokenRefresher {
  /// Refreshes the authentication tokens using the provided refresh token.
  ///
  /// Returns a [TokenRefreshResult] containing the new access and refresh tokens.
  /// Throws an exception if the refresh fails.
  Future<TokenRefreshResult> refreshTokens({required String refreshToken});
}

/// Result of a token refresh operation.
class TokenRefreshResult {
  final String? accessToken;
  final String? refreshToken;

  const TokenRefreshResult({this.accessToken, this.refreshToken});
}
