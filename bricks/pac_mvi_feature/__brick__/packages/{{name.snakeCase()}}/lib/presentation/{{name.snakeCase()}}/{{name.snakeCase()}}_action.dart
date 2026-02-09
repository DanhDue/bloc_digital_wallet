// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}_action.freezed.dart';

@freezed
abstract class {{name.pascalCase()}}Action extends BaseAction with _${{name.pascalCase()}}Action {
  const {{name.pascalCase()}}Action._();

  const factory {{name.pascalCase()}}Action.started() = _Started;
}
