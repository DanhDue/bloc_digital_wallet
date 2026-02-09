// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{subfeature_name.snakeCase()}}_entity.freezed.dart';
part '{{subfeature_name.snakeCase()}}_entity.g.dart';

@freezed
abstract class {{subfeature_name.pascalCase()}}Entity with _${{subfeature_name.pascalCase()}}Entity {
  const {{subfeature_name.pascalCase()}}Entity._();

  @JsonSerializable(includeIfNull: false)
  const factory {{subfeature_name.pascalCase()}}Entity({
    @JsonKey(name: 'id') required String id,
  }) = _{{subfeature_name.pascalCase()}}Entity;

  factory {{subfeature_name.pascalCase()}}Entity.fromJson(Map<String, dynamic> json) =>
      _${{subfeature_name.pascalCase()}}EntityFromJson(json);
}
