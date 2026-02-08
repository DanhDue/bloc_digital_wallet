// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'models/network_selection_ui_model.dart';

part 'network_selection_state.freezed.dart';

enum NetworkSelectionStatus { initial, loading, success, failure }

@freezed
abstract class NetworkSelectionState extends BaseState with _$NetworkSelectionState {
  const factory NetworkSelectionState({
    @Default(NetworkSelectionStatus.initial) NetworkSelectionStatus status,
    @Default(NetworkSelectionUiModel()) NetworkSelectionUiModel uiModel,
    String? errorMessage,
  }) = _NetworkSelectionState;

  const NetworkSelectionState._();
}
