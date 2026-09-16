// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/network_selection_entity.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/presentation/wallet/models/wallet_ui_model.dart';

part 'wallet_state.freezed.dart';

enum WalletStatus { initial, loading, success, failure }

@freezed
abstract class WalletState extends BaseState with _$WalletState {
  const WalletState._();

  const factory WalletState({
    @Default(WalletStatus.initial) WalletStatus status,
    WalletUiModel? uiModel,
    String? errorMessage,
    NetworkSelectionEntity? selectedNetwork,
    WalletEntity? selectedWallet,
  }) = _WalletState;
}
