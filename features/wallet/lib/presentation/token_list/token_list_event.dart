// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_list_event.freezed.dart';

@freezed
abstract class TokenListEvent extends BaseEvent with _$TokenListEvent {
  const factory TokenListEvent.initial() = _Initial;

  const TokenListEvent._();
}
