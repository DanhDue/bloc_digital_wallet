// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_action.freezed.dart';

@freezed
abstract class ScannerAction extends BaseAction with _$ScannerAction {
  const factory ScannerAction.started() = _Started;
  const ScannerAction._() : super();
}
