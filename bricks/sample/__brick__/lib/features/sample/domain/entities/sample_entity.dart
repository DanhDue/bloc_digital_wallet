// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_entity.freezed.dart';

@freezed
abstract class SampleEntity with _$SampleEntity {
  const SampleEntity._();

  const factory SampleEntity({
    required String id,
    required String name,
    // TODO: Add your entity properties here
  }) = _SampleEntity;
}
