// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:logger/d3nexus_logger.dart';

/// Wraps a [delegate] Dio [Interceptor], forwarding each callback only
/// when [module]'s toggle is currently enabled, checked live via
/// [D3NexusLogger.isModuleEnabled] on every call.
///
/// Unlike deciding once at DI-construction time whether to register a
/// third-party interceptor at all, this makes the "Network" module toggle
/// (or any other module) take effect on the very next HTTP call, with no
/// app restart required -- since the check happens per-call, not once at
/// bootstrap. When disabled, the request/response/error simply proceeds
/// through the chain unlogged (`handler.next(...)`), same as if this
/// interceptor were never added.
class ModuleGatedInterceptor extends Interceptor {
  ModuleGatedInterceptor({required this.module, required this.delegate});

  /// The module whose live toggle gates [delegate].
  final String module;

  /// The interceptor to forward to when [module] is enabled.
  final Interceptor delegate;

  bool get _enabled => D3NexusLogger.isModuleEnabled(module);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enabled) {
      delegate.onRequest(options, handler);
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_enabled) {
      delegate.onResponse(response, handler);
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enabled) {
      delegate.onError(err, handler);
    } else {
      handler.next(err);
    }
  }
}
