// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/{{{feature_name.snakeCase()}}}_entity.dart';

part '{{{feature_name.snakeCase()}}}_model.g.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Model
/// ============================================================================
/// Models handle JSON serialization and data transformation.
/// They bridge external data (API/DB) to domain entities.
/// 
/// HOW TO IMPLEMENT:
/// 1. Add properties matching your API/database schema
/// 2. Add @JsonKey annotations for field mapping if needed
/// 3. Implement toEntity() to convert to domain entity
/// 4. Implement fromEntity() for reverse conversion
/// 
/// EXAMPLE - Full model implementation:
/// ```dart
/// @JsonSerializable()
/// class {{feature_name.pascalCase()}}Model {
///   @JsonKey(name: 'id')
///   final String id;
/// 
///   @JsonKey(name: 'name')
///   final String name;
/// 
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
/// 
///   const {{feature_name.pascalCase()}}Model({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
/// 
///   factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
///       _${{feature_name.pascalCase()}}ModelFromJson(json);
/// 
///   Map<String, dynamic> toJson() => _${{feature_name.pascalCase()}}ModelToJson(this);
/// 
///   {{feature_name.pascalCase()}}Entity toEntity() => {{feature_name.pascalCase()}}Entity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
/// 
///   factory {{feature_name.pascalCase()}}Model.fromEntity({{feature_name.pascalCase()}}Entity entity) =>
///       {{feature_name.pascalCase()}}Model(
///         id: entity.id,
///         name: entity.name,
///         createdAt: entity.createdAt,
///       );
/// }
/// ```
/// 
/// AFTER ADDING PROPERTIES: Run build_runner to generate serialization code:
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
/// ============================================================================

@JsonSerializable()
class {{feature_name.pascalCase()}}Model {
  // TODO: Add model properties with @JsonKey annotations

  const {{feature_name.pascalCase()}}Model();

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${{feature_name.pascalCase()}}ModelToJson(this);

  /// Convert to domain entity
  {{feature_name.pascalCase()}}Entity toEntity() => const {{feature_name.pascalCase()}}Entity();

  /// Create from domain entity
  factory {{feature_name.pascalCase()}}Model.fromEntity({{feature_name.pascalCase()}}Entity entity) =>
      const {{feature_name.pascalCase()}}Model();
}
