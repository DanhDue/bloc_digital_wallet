// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}_event.freezed.dart';

@freezed
abstract class {{name.pascalCase()}}Event extends BaseEvent with _${{name.pascalCase()}}Event {
  const factory {{name.pascalCase()}}Event.initial() = _Initial;
  const {{name.pascalCase()}}Event._() : super();
}
