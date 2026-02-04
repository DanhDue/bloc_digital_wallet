// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{name.snakeCase()}}/presentation/{{name.snakeCase()}}/models/{{name.snakeCase()}}_ui_model.dart';

part '{{name.snakeCase()}}_state.freezed.dart';

enum {{name.pascalCase()}}Status { initial, loading, success, failure }

@freezed
abstract class {{name.pascalCase()}}State extends BaseState with _${{name.pascalCase()}}State {
  const factory {{name.pascalCase()}}State({
    @Default({{name.pascalCase()}}Status.initial) {{name.pascalCase()}}Status status,
    {{name.pascalCase()}}UiModel? uiModel,
    String? errorMessage,
  }) = _{{name.pascalCase()}}State;

  const {{name.pascalCase()}}State._() : super();
}
