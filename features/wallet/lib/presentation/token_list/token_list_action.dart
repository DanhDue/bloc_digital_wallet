// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_list_action.freezed.dart';

@freezed
abstract class TokenListAction extends BaseAction with _$TokenListAction {
  const factory TokenListAction.started() = _Started;

  const TokenListAction._();
}
