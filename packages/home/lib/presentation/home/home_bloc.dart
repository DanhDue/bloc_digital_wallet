// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_all_homes_usecase.dart';
import 'home_action.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends MviBloc<HomeAction, HomeState, HomeEvent> {
  final GetAllHomesUseCase _getAllHomesUseCase;

  HomeBloc(this._getAllHomesUseCase) : super(const HomeState()) {
    on<HomeAction>((event, emit) {
      event.map(
        started: (_) => _onStarted(emit),
        onRefresh: (_) => _onRefresh(emit),
        onHomeItemClicked: (e) => _onHomeItemClicked(e.id, emit),
      );
    });
  }

  @override
  void onAction(HomeAction action) {
    add(action);
  }

  FutureOr<void> _onStarted(Emitter<HomeState> emit) async {
    await _loadHomes(emit);
  }

  FutureOr<void> _onRefresh(Emitter<HomeState> emit) async {
    await _loadHomes(emit);
  }

  FutureOr<void> _onHomeItemClicked(String id, Emitter<HomeState> emit) {
    emitEvent(HomeEvent.navigateToDetails(id));
  }

  Future<void> _loadHomes(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _getAllHomesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (success) => emit(state.copyWith(isLoading: false, homes: success)),
    );
  }
}
