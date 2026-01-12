// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/{{{feature_name.snakeCase()}}}_entity.dart';

part '{{{feature_name.snakeCase()}}}_model.freezed.dart';
part '{{{feature_name.snakeCase()}}}_model.g.dart';

@freezed
sealed class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
  const {{feature_name.pascalCase()}}Model._();
  
  const factory {{feature_name.pascalCase()}}Model({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _{{feature_name.pascalCase()}}Model;

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}ModelFromJson(json);

  /// Convert model to entity
  {{feature_name.pascalCase()}}Entity toEntity() {
    return {{feature_name.pascalCase()}}Entity(
      id: id,
      name: name,
    );
  }

  /// Create model from entity
  factory {{feature_name.pascalCase()}}Model.fromEntity({{feature_name.pascalCase()}}Entity entity) {
    return {{feature_name.pascalCase()}}Model(
      id: entity.id,
      name: entity.name,
    );
  }
}
