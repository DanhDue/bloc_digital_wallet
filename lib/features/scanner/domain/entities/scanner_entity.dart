// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';

/// ============================================================================
/// Scanner Entity
/// ============================================================================
/// Entities are pure Dart classes representing business objects.
/// They should NOT have any Flutter or external dependencies.
///
/// HOW TO IMPLEMENT:
/// 1. Define the properties that represent your business data
/// 2. Use const constructor and final fields for immutability
/// 3. Extend Equatable for value equality comparison
///
/// EXAMPLE - Adding properties:
/// ```dart
/// class ScannerEntity extends Equatable {
///   final String id;
///   final String name;
///   final DateTime createdAt;
///   final bool isActive;
///
///   const ScannerEntity({
///     required this.id,
///     required this.name,
///     required this.createdAt,
///     this.isActive = true,
///   });
///
///   @override
///   List<Object?> get props => [id, name, createdAt, isActive];
/// }
/// ```
///
/// BEST PRACTICES:
/// - Keep entities simple and focused on a single concept
/// - Use value objects for complex properties (e.g., Email, Money)
/// - Entities should be serialization-agnostic (no toJson/fromJson)
/// ============================================================================

class ScannerEntity extends Equatable {
  // TODO: Add entity properties
  // final String id;
  // final String name;

  const ScannerEntity();

  @override
  List<Object?> get props => [];
}
