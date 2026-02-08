// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/domain/usecases/get_trends_usecase.dart';
import 'package:trends/presentation/trends/models/trends_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'trends_action.dart';
import 'trends_event.dart';
import 'trends_state.dart';

@injectable
class TrendsBloc extends MviBloc<TrendsAction, TrendsState, TrendsEvent> {
  final GetTrendsUseCase _getTrendsUseCase;

  TrendsBloc(this._getTrendsUseCase) : super(const TrendsState()) {
    on<TrendsAction>((action, emit) {
      action.when(started: () => _onStarted(emit));
    });
  }

  Future<void> _onStarted(Emitter<TrendsState> emit) async {
    emit(state.copyWith(status: TrendsStatus.loading));
    final result = await _getTrendsUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: TrendsStatus.failure, errorMessage: failure.message));
        emitEvent(const TrendsEvent.initial());
      },
      (entity) {
        final uiModel = TrendsUiModel.fromEntity(entity);
        emit(state.copyWith(status: TrendsStatus.success, uiModel: uiModel));
      },
    );
  }
}
