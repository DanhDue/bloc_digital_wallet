// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_event.freezed.dart';

@freezed
abstract class ScannerEvent extends BaseEvent with _$ScannerEvent {
  const factory ScannerEvent.initial() = _Initial;
  const ScannerEvent._() : super();
}
