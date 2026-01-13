// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_ui_model.freezed.dart';
part 'profile_ui_model.g.dart';

@freezed
sealed class ProfileUiModel with _$ProfileUiModel {
  const factory ProfileUiModel({
    // TODO: Add UI properties
    required String id,
    required String title,
  }) = _ProfileUiModel;

  factory ProfileUiModel.fromJson(Map<String, dynamic> json) => _$ProfileUiModelFromJson(json);
}
