// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/presentation/token_list/token_list_action.dart';
import 'package:wallet/presentation/token_list/token_list_event.dart';
import 'package:wallet/presentation/token_list/token_list_state.dart';

@injectable
class TokenListBloc extends MviBloc<TokenListAction, TokenListState, TokenListEvent> {
  TokenListBloc() : super(const TokenListState()) {
    on<TokenListAction>(_onAction);
  }

  Future<void> _onAction(
    TokenListAction action,
    Emitter<TokenListState> emit,
  ) async {
    await action.when(
      started: () async {
        emit(state.copyWith(status: TokenListStatus.loading));
        // TODO: Add logic here
        emit(state.copyWith(status: TokenListStatus.success));
      },
    );
  }
}
