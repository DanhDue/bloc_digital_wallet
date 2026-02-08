// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_list_action.freezed.dart';

@freezed
abstract class WalletListAction extends BaseAction with _$WalletListAction {
  const factory WalletListAction.started() = _Started;
  const factory WalletListAction.toggleBalanceVisibility() = _ToggleBalanceVisibility;

  const WalletListAction._();
}
