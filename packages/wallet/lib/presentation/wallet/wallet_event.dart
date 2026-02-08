// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_event.freezed.dart';

@freezed
abstract class WalletEvent extends BaseEvent with _$WalletEvent {
  const factory WalletEvent.initial() = _Initial;
  const WalletEvent._() : super();
}
