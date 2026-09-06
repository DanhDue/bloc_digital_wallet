// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:{{package_name.snakeCase()}}/domain/entities/{{subfeature_name.snakeCase()}}_entity.dart';

part '{{subfeature_name.snakeCase()}}_model.freezed.dart';
part '{{subfeature_name.snakeCase()}}_model.g.dart';

@freezed
abstract class {{subfeature_name.pascalCase()}}Model with _${{subfeature_name.pascalCase()}}Model {
  const {{subfeature_name.pascalCase()}}Model._();

  @JsonSerializable(includeIfNull: false)
  const factory {{subfeature_name.pascalCase()}}Model({
    @JsonKey(name: 'id') required String id,
  }) = _{{subfeature_name.pascalCase()}}Model;

  factory {{subfeature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{subfeature_name.pascalCase()}}ModelFromJson(json);

  {{subfeature_name.pascalCase()}}Entity toEntity() {
    return {{subfeature_name.pascalCase()}}Entity(
      id: id,
    );
  }
}
