// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';

part 'scanner_model.freezed.dart';
part 'scanner_model.g.dart';

@freezed
abstract class ScannerModel with _$ScannerModel {
  const factory ScannerModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _ScannerModel;

  factory ScannerModel.fromJson(Map<String, dynamic> json) => _$ScannerModelFromJson(json);
}

extension ScannerModelX on ScannerModel {
  ScannerEntity toEntity() {
    return ScannerEntity(id: id, name: name, description: description);
  }
}
