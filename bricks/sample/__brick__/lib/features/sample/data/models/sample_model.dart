// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sample_entity.dart';

part 'sample_model.freezed.dart';
part 'sample_model.g.dart';

@freezed
sealed class SampleModel with _$SampleModel {
  const SampleModel._();

  const factory SampleModel({
    required String id,
    required String name,
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
