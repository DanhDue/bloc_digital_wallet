// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_action.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_event.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_state.dart';

@injectable
class WalletListBloc extends MviBloc<WalletListAction, WalletListState, WalletListEvent> {
  WalletListBloc() : super(const WalletListState()) {
    on<WalletListAction>(_onAction);
  }

  Future<void> _onAction(
    WalletListAction action,
    Emitter<WalletListState> emit,
  ) async {
    await action.when(
      started: () async {
        emit(state.copyWith(status: WalletListStatus.loading));
        // TODO: Add logic here
        emit(state.copyWith(status: WalletListStatus.success));
      },
    );
  }
}
