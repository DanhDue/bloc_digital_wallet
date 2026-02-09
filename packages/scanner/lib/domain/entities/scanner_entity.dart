// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_entity.freezed.dart';
part 'scanner_entity.g.dart';

@freezed
abstract class ScannerEntity with _$ScannerEntity {
  const factory ScannerEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _ScannerEntity;

  factory ScannerEntity.fromJson(Map<String, dynamic> json) => _$ScannerEntityFromJson(json);
}
