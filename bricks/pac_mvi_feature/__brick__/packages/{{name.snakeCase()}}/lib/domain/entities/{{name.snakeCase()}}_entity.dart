// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}_entity.freezed.dart';
part '{{name.snakeCase()}}_entity.g.dart';

@freezed
abstract class {{name.pascalCase()}}Entity with _${{name.pascalCase()}}Entity {
  const {{name.pascalCase()}}Entity._();

  @JsonSerializable(includeIfNull: false)
  const factory {{name.pascalCase()}}Entity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _{{name.pascalCase()}}Entity;

  factory {{name.pascalCase()}}Entity.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}EntityFromJson(json);
}
