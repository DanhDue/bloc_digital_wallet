// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part '{{{name.snakeCase()}}}_ui_model.freezed.dart';
part '{{{name.snakeCase()}}}_ui_model.g.dart';

@freezed
sealed class {{name.pascalCase()}}UiModel with _${{name.pascalCase()}}UiModel {
  const factory {{name.pascalCase()}}UiModel({
    // TODO: Add UI properties
    required String id,
  }) = _{{name.pascalCase()}}UiModel;

  factory {{name.pascalCase()}}UiModel.fromJson(Map<String, dynamic> json) => 
      _${{name.pascalCase()}}UiModelFromJson(json);
}
