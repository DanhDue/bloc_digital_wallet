// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';

import 'wallet_action.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  WalletBloc() : super(const WalletState()) {
    on<WalletAction>((action, emit) {
      action.when(
        started: () => _onStarted(emit),
        selectNetwork: (network) => emit(state.copyWith(selectedNetwork: network)),
        selectWallet: (wallet) => emit(state.copyWith(selectedWallet: wallet)),
      );
    });
  }

  Future<void> _onStarted(Emitter<WalletState> emit) async {
    // TODO: Load actual wallet data here
    emit(state.copyWith(status: WalletStatus.success));
  }
}
