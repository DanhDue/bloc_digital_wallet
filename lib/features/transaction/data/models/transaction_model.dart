// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

/// ============================================================================
/// Transaction Model
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
/// class TransactionModel {
///   @JsonKey(name: 'id')
///   final String id;
///
///   @JsonKey(name: 'name')
///   final String name;
///
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
///
///   const TransactionModel({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
///
///   factory TransactionModel.fromJson(Map<String, dynamic> json) =>
///       _$TransactionModelFromJson(json);
///
///   Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
///
///   TransactionEntity toEntity() => TransactionEntity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
///
///   factory TransactionModel.fromEntity(TransactionEntity entity) =>
///       TransactionModel(
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
class TransactionModel {
  // TODO: Add model properties with @JsonKey annotations

  const TransactionModel();

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  /// Convert to domain entity
  TransactionEntity toEntity() => const TransactionEntity();

  /// Create from domain entity
  factory TransactionModel.fromEntity(TransactionEntity entity) => const TransactionModel();
}
