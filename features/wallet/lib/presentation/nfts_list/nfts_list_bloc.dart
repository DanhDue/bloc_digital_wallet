// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/presentation/nfts_list/nfts_list_action.dart';
import 'package:wallet/presentation/nfts_list/nfts_list_event.dart';
import 'package:wallet/presentation/nfts_list/nfts_list_state.dart';

@injectable
class NftsListBloc extends MviBloc<NftsListAction, NftsListState, NftsListEvent> {
  NftsListBloc() : super(const NftsListState()) {
    on<NftsListAction>(_onAction);
  }

  Future<void> _onAction(NftsListAction action, Emitter<NftsListState> emit) async {
    await action.when(
      started: () async {
        emit(state.copyWith(status: NftsListStatus.loading));
        // TODO: Add logic here
        emit(state.copyWith(status: NftsListStatus.success));
      },
    );
  }
}
