// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trends/domain/entities/trends_entity.dart';

part 'trends_ui_model.freezed.dart';

@freezed
abstract class TrendsUiModel with _$TrendsUiModel {
  const factory TrendsUiModel({required String id, required String name, String? description}) =
      _TrendsUiModel;

  factory TrendsUiModel.fromEntity(TrendsEntity entity) {
    return TrendsUiModel(id: entity.id, name: entity.name, description: entity.description);
  }
}
