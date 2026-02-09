// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';

part 'scanner_ui_model.freezed.dart';

@freezed
abstract class ScannerUiModel with _$ScannerUiModel {
  const factory ScannerUiModel({required String id, required String name, String? description}) =
      _ScannerUiModel;

  factory ScannerUiModel.fromEntity(ScannerEntity entity) {
    return ScannerUiModel(id: entity.id, name: entity.name, description: entity.description);
  }
}
