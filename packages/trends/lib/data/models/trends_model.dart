// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/domain/entities/trends_entity.dart';

part 'trends_model.freezed.dart';
part 'trends_model.g.dart';

@freezed
abstract class TrendsModel with _$TrendsModel {
  const TrendsModel._();

  @JsonSerializable(includeIfNull: false)
  const factory TrendsModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _TrendsModel;

  factory TrendsModel.fromJson(Map<String, dynamic> json) => _$TrendsModelFromJson(json);

  TrendsEntity toEntity() {
    return TrendsEntity(id: id, name: name, description: description);
  }
}
