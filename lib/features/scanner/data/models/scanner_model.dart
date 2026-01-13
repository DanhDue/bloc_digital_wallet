// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/scanner_entity.dart';

part 'scanner_model.freezed.dart';
part 'scanner_model.g.dart';

@freezed
sealed class ScannerModel with _$ScannerModel {
  const ScannerModel._();

  const factory ScannerModel({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _ScannerModel;

  factory ScannerModel.fromJson(Map<String, dynamic> json) => _$ScannerModelFromJson(json);

  /// Convert model to entity
  ScannerEntity toEntity() {
    return ScannerEntity(id: id, name: name);
  }

  /// Create model from entity
  factory ScannerModel.fromEntity(ScannerEntity entity) {
    return ScannerModel(id: entity.id, name: entity.name);
  }
}
