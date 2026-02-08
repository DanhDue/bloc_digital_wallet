// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:wallet/presentation/wallet/models/wallet_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'wallet_action.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase _getWalletUseCase;

  WalletBloc(this._getWalletUseCase) : super(const WalletState()) {
    on<WalletAction>((action, emit) {
      action.when(
        started: () => _onStarted(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final result = await _getWalletUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: WalletStatus.failure, errorMessage: failure.message));
        emitEvent(const WalletEvent.initial());
      },
      (entity) {
        final uiModel = WalletUiModel.fromEntity(entity);
        emit(state.copyWith(status: WalletStatus.success, uiModel: uiModel));
      },
    );
  }
}
