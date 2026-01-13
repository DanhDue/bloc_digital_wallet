// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_ui_model.freezed.dart';
part 'home_ui_model.g.dart';

@freezed
sealed class HomeUiModel with _$HomeUiModel {
  const factory HomeUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _HomeUiModel;

  factory HomeUiModel.fromJson(Map<String, dynamic> json) => _$HomeUiModelFromJson(json);
}
