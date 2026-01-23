// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/scanner_entity.dart';

part 'scanner_model.g.dart';

/// ============================================================================
/// Scanner Model
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
/// class ScannerModel {
///   @JsonKey(name: 'id')
///   final String id;
///
///   @JsonKey(name: 'name')
///   final String name;
///
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
///
///   const ScannerModel({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
///
///   factory ScannerModel.fromJson(Map<String, dynamic> json) =>
///       _$ScannerModelFromJson(json);
///
///   Map<String, dynamic> toJson() => _$ScannerModelToJson(this);
///
///   ScannerEntity toEntity() => ScannerEntity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
///
///   factory ScannerModel.fromEntity(ScannerEntity entity) =>
///       ScannerModel(
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
class ScannerModel {
  // TODO: Add model properties with @JsonKey annotations

  const ScannerModel();

  factory ScannerModel.fromJson(Map<String, dynamic> json) => _$ScannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScannerModelToJson(this);

  /// Convert to domain entity
  ScannerEntity toEntity() => const ScannerEntity();

  /// Create from domain entity
  factory ScannerModel.fromEntity(ScannerEntity entity) => const ScannerModel();
}
