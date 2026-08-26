// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc/bloc.dart';
import 'package:bloc_digital_wallet/logging/module_gated_bloc_observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

class _SpyBlocObserver extends BlocObserver {
  int onEventCalls = 0;
  int onTransitionCalls = 0;
  int onChangeCalls = 0;
  int onErrorCalls = 0;
  int onCreateCalls = 0;
  int onCloseCalls = 0;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    onEventCalls++;
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    onTransitionCalls++;
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    onChangeCalls++;
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    onErrorCalls++;
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    onCreateCalls++;
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    onCloseCalls++;
  }
}

class _CounterCubit extends Cubit<int> {
  _CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

class _FakeLogManager implements ILogManager {
  final Map<String, bool> moduleToggles = <String, bool>{};

  @override
  void setModuleEnabled(String module, bool enabled) => moduleToggles[module] = enabled;

  @override
  bool isModuleEnabled(String module) => moduleToggles[module] ?? true;

  @override
  ILogger getLogger(String module) => throw UnimplementedError();

  @override
  void registerAppender(ILogAppender appender) => throw UnimplementedError();

  @override
  void log(LogRecord record) => throw UnimplementedError();

  @override
  void setAppenderEnabled(String appenderId, bool enabled) => throw UnimplementedError();
}

void main() {
  late _SpyBlocObserver delegate;
  late _FakeLogManager manager;
  late ModuleGatedBlocObserver observer;
  late _CounterCubit cubit;

  setUp(() {
    delegate = _SpyBlocObserver();
    manager = _FakeLogManager();
    D3NexusLogger.initialize(manager);
    observer = ModuleGatedBlocObserver(module: 'Framework', delegate: delegate);
    cubit = _CounterCubit();
  });

  tearDown(() => cubit.close());

  test('when Framework is enabled, onChange/onTransition forward to the delegate', () {
    observer.onCreate(cubit);
    cubit.increment();
    observer.onChange(cubit, const Change(currentState: 0, nextState: 1));

    expect(delegate.onCreateCalls, 1);
    expect(delegate.onChangeCalls, 1);
  });

  test('when Framework is enabled, onError forwards to the delegate', () {
    observer.onError(cubit, Exception('boom'), StackTrace.current);
    expect(delegate.onErrorCalls, 1);
  });

  test('when Framework is enabled, onClose forwards to the delegate', () {
    observer.onClose(cubit);
    expect(delegate.onCloseCalls, 1);
  });

  group('when Framework is disabled', () {
    setUp(() => manager.setModuleEnabled('Framework', false));

    test('onCreate/onChange/onClose do not forward to the delegate', () {
      observer.onCreate(cubit);
      observer.onChange(cubit, const Change(currentState: 0, nextState: 1));
      observer.onClose(cubit);

      expect(delegate.onCreateCalls, 0);
      expect(delegate.onChangeCalls, 0);
      expect(delegate.onCloseCalls, 0);
    });

    test('onError does not forward to the delegate', () {
      observer.onError(cubit, Exception('boom'), StackTrace.current);
      expect(delegate.onErrorCalls, 0);
    });
  });

  test('re-enabling after a disable takes effect on the very next call, live', () {
    manager.setModuleEnabled('Framework', false);
    observer.onCreate(cubit);
    expect(delegate.onCreateCalls, 0);

    manager.setModuleEnabled('Framework', true);
    observer.onCreate(cubit);
    expect(delegate.onCreateCalls, 1);
  });
}
