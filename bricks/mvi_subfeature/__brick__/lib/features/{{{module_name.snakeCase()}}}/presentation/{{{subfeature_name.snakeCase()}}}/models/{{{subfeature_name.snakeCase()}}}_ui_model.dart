// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part '{{{subfeature_name.snakeCase()}}}_ui_model.freezed.dart';
part '{{{subfeature_name.snakeCase()}}}_ui_model.g.dart';

@freezed
sealed class {{subfeature_name.pascalCase()}}UiModel with _${{subfeature_name.pascalCase()}}UiModel {
  const factory {{subfeature_name.pascalCase()}}UiModel({
    // TODO: Add UI properties
    required String id,
    required String title,
  }) = _{{subfeature_name.pascalCase()}}UiModel;

  factory {{subfeature_name.pascalCase()}}UiModel.fromJson(Map<String, dynamic> json) => 
      _${{subfeature_name.pascalCase()}}UiModelFromJson(json);
}
