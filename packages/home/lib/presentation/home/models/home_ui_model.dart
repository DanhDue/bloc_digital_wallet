// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home/domain/entities/home_entity.dart';

part 'home_ui_model.freezed.dart';

@freezed
abstract class HomeUiModel with _$HomeUiModel {
  const factory HomeUiModel({required String id, required String name, String? description}) =
      _HomeUiModel;

  factory HomeUiModel.fromEntity(HomeEntity entity) {
    return HomeUiModel(id: entity.id, name: entity.name, description: entity.description);
  }
}
