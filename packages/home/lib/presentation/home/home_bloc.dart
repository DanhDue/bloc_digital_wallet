// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';

import 'package:home/presentation/home/home_action.dart';
import 'package:home/presentation/home/home_event.dart';
import 'package:home/presentation/home/home_state.dart';

@injectable
class HomeBloc extends MviBloc<HomeAction, HomeState, HomeEvent> {
  HomeBloc() : super(const HomeState()) {
    on<HomeAction>((event, emit) async {
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
  void onAction(HomeAction action) {
    add(action);
  }

  FutureOr<void> _onStarted(Emitter<HomeState> emit) {
    // No-op: home shell has no data to load on start.
  }

  FutureOr<void> _onTabChanged(int index, Emitter<HomeState> emit) {
    emit(state.copyWith(currentTabIndex: index));
  }

  FutureOr<void> _onTabDoubleTapped(int index, Emitter<HomeState> emit) {
    if (state.currentTabIndex != index) {
      emit(state.copyWith(currentTabIndex: index));
    }
    // TODO: Notify child tab to pop to root / scroll to top.
  }

  FutureOr<void> _onBackPressed(Emitter<HomeState> emit) {
    final now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > _exitTimeWindow) {
      _lastBackPressTime = now;
      emitEvent(const HomeEvent.showExitToast());
      return null;
    }
    emitEvent(const HomeEvent.exitApp());
  }
}
