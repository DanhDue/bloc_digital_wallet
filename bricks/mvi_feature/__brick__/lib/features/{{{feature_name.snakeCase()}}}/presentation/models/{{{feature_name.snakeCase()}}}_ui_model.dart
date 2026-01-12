// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part '{{{feature_name.snakeCase()}}}_ui_model.freezed.dart';
part '{{{feature_name.snakeCase()}}}_ui_model.g.dart';

@freezed
sealed class {{feature_name.pascalCase()}}UiModel with _${{feature_name.pascalCase()}}UiModel {
  const factory {{feature_name.pascalCase()}}UiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _{{feature_name.pascalCase()}}UiModel;

  factory {{feature_name.pascalCase()}}UiModel.fromJson(Map<String, dynamic> json) => 
      _${{feature_name.pascalCase()}}UiModelFromJson(json);
}
