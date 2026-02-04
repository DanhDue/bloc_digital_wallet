// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Base exception class
class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server exception
class ServerException extends AppException {
  ServerException({required super.message, super.code, super.originalException});
}

/// Cache exception
class CacheException extends AppException {
  CacheException({required super.message, super.code, super.originalException});
}

/// Network exception
class NetworkException extends AppException {
  NetworkException({required super.message, super.code, super.originalException});
}

/// Validation exception
class ValidationException extends AppException {
  ValidationException({required super.message, super.code, super.originalException});
}
