// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_selection_entity.freezed.dart';
part 'network_selection_entity.g.dart';

@freezed
abstract class NetworkSelectionEntity with _$NetworkSelectionEntity {
  const factory NetworkSelectionEntity({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'logo') String? logo,
  }) = _NetworkSelectionEntity;

  const NetworkSelectionEntity._();

  factory NetworkSelectionEntity.fromJson(Map<String, dynamic> json) =>
      _$NetworkSelectionEntityFromJson(json);
}
