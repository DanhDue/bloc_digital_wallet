// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/shell/shell_action.dart';
import 'package:bloc_digital_wallet/shell/shell_event.dart';
import 'package:bloc_digital_wallet/shell/shell_state.dart';

@injectable
class ShellBloc extends MviBloc<ShellAction, ShellState, ShellEvent> {
  ShellBloc() : super(const ShellState()) {
    on<ShellAction>((event, emit) async {
      await event.map(
        started: (_) => _onStarted(emit),
        tabChanged: (e) => _onTabChanged(e.index, emit),
        tabDoubleTapped: (e) => _onTabDoubleTapped(e.index, emit),
        backPressed: (_) => _onBackPressed(emit),
      );
    });
  }

  DateTime? _lastBackPressTime;
  static const _exitTimeWindow = Duration(seconds: 2);

  @override
  void onAction(ShellAction action) {
    add(action);
  }

  FutureOr<void> _onStarted(Emitter<ShellState> emit) {
    // No-op: shell has no data to load on start.
  }

  FutureOr<void> _onTabChanged(int index, Emitter<ShellState> emit) {
    emit(state.copyWith(currentTabIndex: index));
  }

  FutureOr<void> _onTabDoubleTapped(int index, Emitter<ShellState> emit) {
    if (state.currentTabIndex != index) {
      emit(state.copyWith(currentTabIndex: index));
    }
    // TODO: Notify child tab to pop to root / scroll to top.
  }

  FutureOr<void> _onBackPressed(Emitter<ShellState> emit) {
    final now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > _exitTimeWindow) {
      _lastBackPressTime = now;
      emitEvent(const ShellEvent.showExitToast());
      return null;
    }
    emitEvent(const ShellEvent.exitApp());
  }
}
