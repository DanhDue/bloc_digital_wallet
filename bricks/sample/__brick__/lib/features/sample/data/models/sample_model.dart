// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/features/sample/domain/entities/sample_entity.dart';

part 'sample_model.freezed.dart';
part 'sample_model.g.dart';

@freezed
abstract class SampleModel with _$SampleModel {
  const SampleModel._();

  @JsonSerializable(includeIfNull: false)
  const factory SampleModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    // TODO: Add your model properties here
  }) = _SampleModel;

  factory SampleModel.fromJson(Map<String, dynamic> json) => _$SampleModelFromJson(json);

  /// Convert model to entity
  SampleEntity toEntity() {
    return SampleEntity(id: id, name: name);
  }

  /// Create model from entity
  factory SampleModel.fromEntity(SampleEntity entity) {
    return SampleModel(id: entity.id, name: entity.name);
  }
}
