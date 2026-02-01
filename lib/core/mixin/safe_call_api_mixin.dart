// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Mixin for safe API calls with proper error handling.
/// Following SRP: each error type has its own handler function.
mixin SafeCallApiMixin {
  Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() call) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }

      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      final talker = getIt<Talker>();
      talker.handle(e, StackTrace.current, 'Dio API Error');
      return Left(_handleDioError(e));
    } on SocketException catch (e) {
      return Left(NetworkFailure(message: e.message, exception: e));
    } on TypeError catch (e) {
      final talker = getIt<Talker>();
      talker.handle(e, StackTrace.current, 'Type Error (JSON Parsing?)');
      return Left(UnknownFailure(message: 'Data parsing error', exception: e));
    } catch (e, s) {
      final talker = getIt<Talker>();
      talker.handle(e, s, 'Unknown API Error');
      return Left(UnknownFailure(message: e.toString(), exception: e));
    }
  }

  Failure _handleDioError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => _handleTimeoutError(),
      DioExceptionType.badResponse => _handleBadResponseError(error),
      DioExceptionType.cancel => const UnknownFailure(message: 'Request cancelled'),
      DioExceptionType.unknown => _handleUnknownError(error),
      _ => ServerFailure(message: error.message ?? 'Unknown error', exception: error),
    };
  }

  Failure _handleTimeoutError() {
    return const NetworkFailure(message: 'Connection timeout');
  }

  Failure _handleBadResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    String message = error.message ?? 'Unknown server error';

    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'];
    }

    return switch (statusCode) {
      401 => AuthenticationFailure(message: message, code: statusCode),
      403 => AuthorizationFailure(message: message, code: statusCode),
      404 => NotFoundFailure(message: message, code: statusCode),
      _ => ServerFailure(message: message, code: statusCode, exception: error),
    };
  }

  Failure _handleUnknownError(DioException error) {
    if (error.error is SocketException) {
      return const NetworkFailure(message: 'No internet connection');
    }
    return ServerFailure(message: error.message ?? 'Unknown error', exception: error);
  }
}
