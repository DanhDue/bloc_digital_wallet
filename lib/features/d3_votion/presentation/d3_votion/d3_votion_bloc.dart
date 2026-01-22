// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/usecases/get_d3_votion_usecase.dart';
import 'd3_votion_action.dart';
import 'd3_votion_state.dart';
import 'd3_votion_event.dart';

@injectable
class D3VotionBloc extends MviBloc<D3VotionAction, D3VotionState, D3VotionEvent> {
  final GetD3VotionUseCase _getD3VotionUseCase;

  D3VotionBloc(this._getD3VotionUseCase) : super(const D3VotionInitial()) {
    handleActionDroppable<GetD3VotionAction>(_onGetD3Votion);
  }

  @override
  void onAction(D3VotionAction action) {
    add(action);
  }

  Future<void> _onGetD3Votion(GetD3VotionAction action, Emitter<D3VotionState> emit) async {
    emit(const D3VotionLoading());
    final result = await _getD3VotionUseCase(action.word);
    result.fold(
      (failure) => emit(D3VotionError(failure.message)),
      (data) => emit(D3VotionLoaded(data)),
    );
  }
}
