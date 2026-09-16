// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/presentation/wallet_list/models/wallet_list_ui_model.dart';

part 'wallet_list_state.freezed.dart';

enum WalletListStatus { initial, loading, success, failure }

@freezed
abstract class WalletListState extends BaseState with _$WalletListState {
  const WalletListState._();

  const factory WalletListState({
    @Default(WalletListStatus.initial) WalletListStatus status,
    @Default(WalletListUiModel()) WalletListUiModel uiModel,
    String? errorMessage,
  }) = _WalletListState;
}
