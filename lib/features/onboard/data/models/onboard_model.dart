// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/onboard_entity.dart';

part 'onboard_model.g.dart';

/// ============================================================================
/// Onboard Model
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
/// class OnboardModel {
///   @JsonKey(name: 'id')
///   final String id;
///
///   @JsonKey(name: 'name')
///   final String name;
///
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
///
///   const OnboardModel({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
///
///   factory OnboardModel.fromJson(Map<String, dynamic> json) =>
///       _$OnboardModelFromJson(json);
///
///   Map<String, dynamic> toJson() => _$OnboardModelToJson(this);
///
///   OnboardEntity toEntity() => OnboardEntity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
///
///   factory OnboardModel.fromEntity(OnboardEntity entity) =>
///       OnboardModel(
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
class OnboardModel {
  // TODO: Add model properties with @JsonKey annotations

  const OnboardModel();

  factory OnboardModel.fromJson(Map<String, dynamic> json) => _$OnboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardModelToJson(this);

  /// Convert to domain entity
  OnboardEntity toEntity() => const OnboardEntity();

  /// Create from domain entity
  factory OnboardModel.fromEntity(OnboardEntity entity) => const OnboardModel();
}
