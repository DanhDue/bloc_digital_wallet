// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_ui_model.freezed.dart';
part 'sample_ui_model.g.dart';

@freezed
sealed class SampleUiModel with _$SampleUiModel {
  const factory SampleUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _SampleUiModel;

  factory SampleUiModel.fromJson(Map<String, dynamic> json) => 
      _$SampleUiModelFromJson(json);
}
