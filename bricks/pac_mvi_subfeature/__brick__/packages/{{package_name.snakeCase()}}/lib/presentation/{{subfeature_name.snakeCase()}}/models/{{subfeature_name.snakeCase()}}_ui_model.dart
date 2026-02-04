// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{subfeature_name.snakeCase()}}_ui_model.freezed.dart';

@freezed
abstract class {{subfeature_name.pascalCase()}}UiModel with _${{subfeature_name.pascalCase()}}UiModel {
  const factory {{subfeature_name.pascalCase()}}UiModel({
    @Default('') String title,
  }) = _{{subfeature_name.pascalCase()}}UiModel;
}
