// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/{{{feature_name.snakeCase()}}}_entity.dart';

part '{{feature_name.snakeCase()}}_model.freezed.dart';
part '{{feature_name.snakeCase()}}_model.g.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Model
/// ============================================================================
/// Models handle JSON serialization and data transformation.
/// They bridge external data (API/DB) to domain entities.
/// 
/// HOW TO IMPLEMENT:
/// 1. Add properties matching your API/database schema
/// 2. Use @JsonKey annotations for field mapping if needed
/// 3. Implement toEntity() to convert to domain entity
/// 4. Implement fromEntity() for reverse conversion
/// 
/// EXAMPLE - Full model implementation:
/// ```dart
/// @freezed
/// abstract class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
///   const {{feature_name.pascalCase()}}Model._();
///
///   const factory {{feature_name.pascalCase()}}Model({
///     @JsonKey(name: 'id') String? id,
///     @JsonKey(name: 'name') String? name,
///   }) = _{{feature_name.pascalCase()}}Model;
///
///   factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
///       _${{feature_name.pascalCase()}}ModelFromJson(json);
/// 
///   {{feature_name.pascalCase()}}Entity toEntity() => {{feature_name.pascalCase()}}Entity(
///     id: id ?? '',
///     name: name ?? '',
///   );
/// }
/// ```
/// ============================================================================

@freezed
abstract class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
  const {{feature_name.pascalCase()}}Model._();

  const factory {{feature_name.pascalCase()}}Model({
    // TODO: Add model properties with @JsonKey annotations
    // @JsonKey(name: 'id') String? id,
  }) = _{{feature_name.pascalCase()}}Model;

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}ModelFromJson(json);

  /// Convert to domain entity
  {{feature_name.pascalCase()}}Entity toEntity() {
    return const {{feature_name.pascalCase()}}Entity(
      // id: id ?? '',
    );
  }
}
