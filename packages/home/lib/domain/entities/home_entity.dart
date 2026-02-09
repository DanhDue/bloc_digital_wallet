// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_entity.freezed.dart';
part 'home_entity.g.dart';

@freezed
abstract class HomeEntity with _$HomeEntity {
  const factory HomeEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _HomeEntity;

  factory HomeEntity.fromJson(Map<String, dynamic> json) => _$HomeEntityFromJson(json);
}
