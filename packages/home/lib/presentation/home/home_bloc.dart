// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:home/domain/usecases/get_home_usecase.dart';
import 'package:home/presentation/home/models/home_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_action.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends MviBloc<HomeAction, HomeState, HomeEvent> {
  final GetHomeUseCase _getHomeUseCase;

  HomeBloc(this._getHomeUseCase) : super(const HomeState()) {
    on<HomeAction>((action, emit) {
      action.when(started: () => _onStarted(emit));
    });
  }

  Future<void> _onStarted(Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: HomeStatus.failure, errorMessage: failure.message));
        emitEvent(const HomeEvent.initial());
      },
      (entity) {
        final uiModel = HomeUiModel.fromEntity(entity);
        emit(state.copyWith(status: HomeStatus.success, uiModel: uiModel));
      },
    );
  }
}
