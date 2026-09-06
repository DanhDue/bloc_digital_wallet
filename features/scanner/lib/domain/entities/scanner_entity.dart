// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_entity.freezed.dart';

@freezed
abstract class ScannerEntity with _$ScannerEntity {
  const ScannerEntity._();

  const factory ScannerEntity({required String id, required String name, String? description}) =
      _ScannerEntity;
}
