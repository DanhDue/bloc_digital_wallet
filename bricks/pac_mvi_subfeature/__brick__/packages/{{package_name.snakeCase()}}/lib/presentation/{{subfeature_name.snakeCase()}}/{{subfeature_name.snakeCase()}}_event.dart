// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{subfeature_name.snakeCase()}}_event.freezed.dart';

@freezed
abstract class {{subfeature_name.pascalCase()}}Event extends BaseEvent with _${{subfeature_name.pascalCase()}}Event {
  const {{subfeature_name.pascalCase()}}Event._();

  const factory {{subfeature_name.pascalCase()}}Event.initial() = _Initial;
}
