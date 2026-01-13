// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_ui_model.freezed.dart';
part 'trends_ui_model.g.dart';

@freezed
sealed class TrendsUiModel with _$TrendsUiModel {
  const factory TrendsUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _TrendsUiModel;

  factory TrendsUiModel.fromJson(Map<String, dynamic> json) => _$TrendsUiModelFromJson(json);
}
