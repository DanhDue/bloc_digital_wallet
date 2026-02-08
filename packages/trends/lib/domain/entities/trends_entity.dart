// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_entity.freezed.dart';
part 'trends_entity.g.dart';

@freezed
abstract class TrendsEntity with _$TrendsEntity {
  const factory TrendsEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _TrendsEntity;

  factory TrendsEntity.fromJson(Map<String, dynamic> json) => _$TrendsEntityFromJson(json);
}
