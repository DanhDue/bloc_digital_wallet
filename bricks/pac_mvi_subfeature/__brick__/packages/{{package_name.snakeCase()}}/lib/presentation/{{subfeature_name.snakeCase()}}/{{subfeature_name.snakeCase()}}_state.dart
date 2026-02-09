// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{package_name.snakeCase()}}/presentation/{{subfeature_name.snakeCase()}}/models/{{subfeature_name.snakeCase()}}_ui_model.dart';

part '{{subfeature_name.snakeCase()}}_state.freezed.dart';

enum {{subfeature_name.pascalCase()}}Status { initial, loading, success, failure }

@freezed
abstract class {{subfeature_name.pascalCase()}}State extends BaseState with _${{subfeature_name.pascalCase()}}State {
  const {{subfeature_name.pascalCase()}}State._();

  const factory {{subfeature_name.pascalCase()}}State({
    @Default({{subfeature_name.pascalCase()}}Status.initial) {{subfeature_name.pascalCase()}}Status status,
    @Default({{subfeature_name.pascalCase()}}UiModel()) {{subfeature_name.pascalCase()}}UiModel uiModel,
    String? errorMessage,
  }) = _{{subfeature_name.pascalCase()}}State;
}
