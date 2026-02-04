// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{subfeature_name.snakeCase()}}_action.freezed.dart';

@freezed
abstract class {{subfeature_name.pascalCase()}}Action extends BaseAction with _${{subfeature_name.pascalCase()}}Action {
  const factory {{subfeature_name.pascalCase()}}Action.started() = _Started;

  const {{subfeature_name.pascalCase()}}Action._();
}
