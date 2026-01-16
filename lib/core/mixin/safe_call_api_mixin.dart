// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../di/injection.dart';
import '../errors/failures.dart';

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
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = error.message ?? 'Unknown server error';

        if (data is Map<String, dynamic> && data.containsKey('message')) {
          message = data['message'];
        }

        if (statusCode == 401) {
          return AuthenticationFailure(message: message, code: statusCode);
        } else if (statusCode == 403) {
          return AuthorizationFailure(message: message, code: statusCode);
        } else if (statusCode == 404) {
          return NotFoundFailure(message: message, code: statusCode);
        }

        return ServerFailure(message: message, code: statusCode, exception: error);
      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request cancelled');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure(message: 'No internet connection');
        }
        return ServerFailure(message: error.message ?? 'Unknown error', exception: error);
      default:
        return ServerFailure(message: error.message ?? 'Unknown error', exception: error);
    }
  }
}
