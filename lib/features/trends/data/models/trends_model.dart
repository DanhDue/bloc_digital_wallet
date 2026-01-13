// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trends_entity.dart';

part 'trends_model.freezed.dart';
part 'trends_model.g.dart';

@freezed
sealed class TrendsModel with _$TrendsModel {
  const TrendsModel._();

  const factory TrendsModel({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _TrendsModel;

  factory TrendsModel.fromJson(Map<String, dynamic> json) => _$TrendsModelFromJson(json);

  /// Convert model to entity
  TrendsEntity toEntity() {
    return TrendsEntity(id: id, name: name);
  }

  /// Create model from entity
  factory TrendsModel.fromEntity(TrendsEntity entity) {
    return TrendsModel(id: entity.id, name: entity.name);
  }
}
