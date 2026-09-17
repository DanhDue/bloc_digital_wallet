// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/network_selection_entity.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

part 'wallet_action.freezed.dart';

@freezed
abstract class WalletAction extends BaseAction with _$WalletAction {
  const WalletAction._();

  const factory WalletAction.started() = _Started;
  const factory WalletAction.selectNetwork(NetworkSelectionEntity network) = _SelectNetwork;
  const factory WalletAction.selectWallet(WalletEntity wallet) = _SelectWallet;
}
