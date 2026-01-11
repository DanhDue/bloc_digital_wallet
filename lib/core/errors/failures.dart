// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic exception;

  const Failure({required this.message, this.code, this.exception});

  @override
  List<Object?> get props => [message, code, exception];
}

/// Server/API failure
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code, super.exception});
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.exception});
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.exception});
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.exception,
  });
}

/// Authentication failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
    super.exception,
  });
}

/// Authorization failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.code,
    super.exception,
  });
}

/// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code, super.exception});
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code, super.exception});
}
