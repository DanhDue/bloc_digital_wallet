// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_ui_model.freezed.dart';
part 'scanner_ui_model.g.dart';

@freezed
sealed class ScannerUiModel with _$ScannerUiModel {
  const factory ScannerUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _ScannerUiModel;

  factory ScannerUiModel.fromJson(Map<String, dynamic> json) => _$ScannerUiModelFromJson(json);
}
