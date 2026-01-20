// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/wallet_entity.dart';

part 'wallet_model.g.dart';

/// ============================================================================
/// Wallet Model
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
/// class WalletModel {
///   @JsonKey(name: 'id')
///   final String id;
///
///   @JsonKey(name: 'name')
///   final String name;
///
///   @JsonKey(name: 'created_at')
///   final DateTime createdAt;
///
///   const WalletModel({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///   });
///
///   factory WalletModel.fromJson(Map<String, dynamic> json) =>
///       _$WalletModelFromJson(json);
///
///   Map<String, dynamic> toJson() => _$WalletModelToJson(this);
///
///   WalletEntity toEntity() => WalletEntity(
///     id: id,
///     name: name,
///     createdAt: createdAt,
///   );
///
///   factory WalletModel.fromEntity(WalletEntity entity) =>
///       WalletModel(
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
class WalletModel {
  // TODO: Add model properties with @JsonKey annotations

  const WalletModel();

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);

  /// Convert to domain entity
  WalletEntity toEntity() => const WalletEntity();

  /// Create from domain entity
  factory WalletModel.fromEntity(WalletEntity entity) => const WalletModel();
}
