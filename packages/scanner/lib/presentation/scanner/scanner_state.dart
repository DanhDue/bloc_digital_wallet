// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scanner/presentation/scanner/models/scanner_ui_model.dart';

part 'scanner_state.freezed.dart';

enum ScannerStatus { initial, loading, success, failure }

@freezed
abstract class ScannerState extends BaseState with _$ScannerState {
  const factory ScannerState({
    @Default(ScannerStatus.initial) ScannerStatus status,
    ScannerUiModel? uiModel,
    String? errorMessage,
  }) = _ScannerState;

  const ScannerState._() : super();
}
