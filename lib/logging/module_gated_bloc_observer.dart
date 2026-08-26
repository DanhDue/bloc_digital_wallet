// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc/bloc.dart';
import 'package:logger/d3nexus_logger.dart';

/// Wraps a [delegate] [BlocObserver], forwarding each callback only when
/// [module]'s toggle is currently enabled, checked live via
/// [D3NexusLogger.isModuleEnabled] on every call.
///
/// `TalkerBlocObserver` (from `talker_bloc_logger`) writes directly to
/// `Talker` -- like `TalkerDioLogger`, it's a third-party observer, not an
/// `ILogAppender`, so it never goes through `D3NexusLogger`/
/// `LogManagerImpl`'s dispatch on its own. This wrapper is what makes a
/// module toggle apply to it live, with no app restart required, same
/// pattern as `ModuleGatedInterceptor` for Dio.
class ModuleGatedBlocObserver extends BlocObserver {
  ModuleGatedBlocObserver({required this.module, required this.delegate});

  /// The module whose live toggle gates [delegate].
  final String module;

  /// The observer to forward to when [module] is enabled.
  final BlocObserver delegate;

  bool get _enabled => D3NexusLogger.isModuleEnabled(module);

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (_enabled) delegate.onCreate(bloc);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (_enabled) delegate.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (_enabled) delegate.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    if (_enabled) delegate.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (_enabled) delegate.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (_enabled) delegate.onClose(bloc);
  }
}
