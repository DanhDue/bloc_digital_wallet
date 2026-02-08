// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/presentation/trends/models/trends_ui_model.dart';

part 'trends_state.freezed.dart';

enum TrendsStatus { initial, loading, success, failure }

@freezed
abstract class TrendsState extends BaseState with _$TrendsState {
  const factory TrendsState({
    @Default(TrendsStatus.initial) TrendsStatus status,
    TrendsUiModel? uiModel,
    String? errorMessage,
  }) = _TrendsState;

  const TrendsState._() : super();
}
