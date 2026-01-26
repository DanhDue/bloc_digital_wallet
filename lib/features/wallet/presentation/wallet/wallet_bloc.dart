// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'wallet_action.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';

/// ============================================================================
/// Wallet BLoC
/// ============================================================================
/// The BLoC processes Actions and emits States/Events.
@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  WalletBloc() : super(const WalletInitial()) {
    handleActionDroppable<InitWalletAction>(_onInit);
    handleActionDroppable<SelectNetworkAction>(_onSelectNetwork);
    handleActionDroppable<SelectWalletAction>(_onSelectWallet);
  }

  Future<void> _onInit(InitWalletAction action, Emitter<WalletState> emit) async {
    // TODO: Load actual wallet data here
    emit(const WalletSuccess());
  }

  Future<void> _onSelectNetwork(SelectNetworkAction action, Emitter<WalletState> emit) async {
    final currentState = state;
    if (currentState is WalletSuccess) {
      emit(currentState.copyWith(selectedNetwork: action.network));
    }
  }

  Future<void> _onSelectWallet(SelectWalletAction action, Emitter<WalletState> emit) async {
    final currentState = state;
    if (currentState is WalletSuccess) {
      emit(currentState.copyWith(selectedWallet: action.wallet));
    }
  }
}
