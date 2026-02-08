// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'models/token_list_ui_model.dart';

part 'token_list_state.freezed.dart';

enum TokenListStatus { initial, loading, success, failure }

@freezed
abstract class TokenListState extends BaseState with _$TokenListState {
  const factory TokenListState({
    @Default(TokenListStatus.initial) TokenListStatus status,
    @Default(TokenListUiModel()) TokenListUiModel uiModel,
    String? errorMessage,
  }) = _TokenListState;

  const TokenListState._();
}
