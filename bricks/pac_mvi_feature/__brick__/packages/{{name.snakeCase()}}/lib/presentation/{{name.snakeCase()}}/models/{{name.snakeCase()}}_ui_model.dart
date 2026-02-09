// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';

part '{{name.snakeCase()}}_ui_model.freezed.dart';

@freezed
abstract class {{name.pascalCase()}}UiModel with _${{name.pascalCase()}}UiModel {
  const {{name.pascalCase()}}UiModel._();

  const factory {{name.pascalCase()}}UiModel({
    required String id,
    required String name,
    String? description,
  }) = _{{name.pascalCase()}}UiModel;

  factory {{name.pascalCase()}}UiModel.fromEntity({{name.pascalCase()}}Entity entity) {
    return {{name.pascalCase()}}UiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
    );
  }
}
