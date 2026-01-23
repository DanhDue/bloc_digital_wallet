// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/trends_entity.dart';

part 'trends_model.g.dart';

/// ============================================================================
/// Trends Model
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
/// class TrendsModel {
///   @JsonKey(name: 'id')
///   final String id;
///
///   @JsonKey(name: 'name')
///   final String name;
///
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
///
///   const TrendsModel({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
///
///   factory TrendsModel.fromJson(Map<String, dynamic> json) =>
///       _$TrendsModelFromJson(json);
///
///   Map<String, dynamic> toJson() => _$TrendsModelToJson(this);
///
///   TrendsEntity toEntity() => TrendsEntity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
///
///   factory TrendsModel.fromEntity(TrendsEntity entity) =>
///       TrendsModel(
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
class TrendsModel {
  // TODO: Add model properties with @JsonKey annotations

  const TrendsModel();

  factory TrendsModel.fromJson(Map<String, dynamic> json) => _$TrendsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrendsModelToJson(this);

  /// Convert to domain entity
  TrendsEntity toEntity() => const TrendsEntity();

  /// Create from domain entity
  factory TrendsModel.fromEntity(TrendsEntity entity) => const TrendsModel();
}
