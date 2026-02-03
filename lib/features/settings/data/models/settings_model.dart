// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/settings_entity.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
sealed class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  const factory SettingsModel({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);

  /// Convert model to entity
  SettingsEntity toEntity() {
    return SettingsEntity(id: id, name: name);
  }

  /// Create model from entity
  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(id: entity.id, name: entity.name);
  }
}
