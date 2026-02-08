// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/wallet_entity.dart';

part 'wallet_list_ui_model.freezed.dart';

@freezed
abstract class WalletListUiModel with _$WalletListUiModel {
  const factory WalletListUiModel({
    @Default([]) List<WalletEntity> wallets,
    @Default(false) bool isBalanceHidden,
    @Default(false) bool isBalanceLoading,
  }) = _WalletListUiModel;
}
