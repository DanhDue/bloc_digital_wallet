// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_ui_model.freezed.dart';

@freezed
abstract class SampleUiModel with _$SampleUiModel {
  const SampleUiModel._();

  const factory SampleUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _SampleUiModel;
}
