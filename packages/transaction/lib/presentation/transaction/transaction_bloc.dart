// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:transaction/presentation/transaction/models/transaction_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaction_action.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

@injectable
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  final GetTransactionUseCase _getTransactionUseCase;

  TransactionBloc(this._getTransactionUseCase) : super(const TransactionState()) {
    on<TransactionAction>((action, emit) {
      action.when(
        started: () => _onStarted(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<TransactionState> emit) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    final result = await _getTransactionUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: TransactionStatus.failure, errorMessage: failure.message));
        emitEvent(const TransactionEvent.initial());
      },
      (entity) {
        final uiModel = TransactionUiModel.fromEntity(entity);
        emit(state.copyWith(status: TransactionStatus.success, uiModel: uiModel));
      },
    );
  }
}
