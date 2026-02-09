// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_list_event.freezed.dart';

@freezed
abstract class WalletListEvent extends BaseEvent with _$WalletListEvent {
  const WalletListEvent._();

  const factory WalletListEvent.initial() = _Initial;
}
