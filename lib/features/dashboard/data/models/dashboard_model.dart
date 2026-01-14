// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/dashboard_entity.dart';

part 'dashboard_model.g.dart';

/// ============================================================================
/// Dashboard Model
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
/// class DashboardModel {
///   @JsonKey(name: 'id')
///   final String id;
///
///   @JsonKey(name: 'name')
///   final String name;
///
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
///
///   const DashboardModel({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
///
///   factory DashboardModel.fromJson(Map<String, dynamic> json) =>
///       _$DashboardModelFromJson(json);
///
///   Map<String, dynamic> toJson() => _$DashboardModelToJson(this);
///
///   DashboardEntity toEntity() => DashboardEntity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
///
///   factory DashboardModel.fromEntity(DashboardEntity entity) =>
///       DashboardModel(
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
class DashboardModel {
  // TODO: Add model properties with @JsonKey annotations

  const DashboardModel();

  factory DashboardModel.fromJson(Map<String, dynamic> json) => _$DashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);

  /// Convert to domain entity
  DashboardEntity toEntity() => const DashboardEntity();

  /// Create from domain entity
  factory DashboardModel.fromEntity(DashboardEntity entity) => const DashboardModel();
}
