// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part '{{feature_name.snakeCase()}}_entity.freezed.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Entity
/// ============================================================================
/// Entities are pure Dart classes representing business objects.
/// They should NOT have any Flutter or external dependencies.
/// 
/// HOW TO IMPLEMENT:
/// 1. Define the properties that represent your business data
/// 2. Use const constructor and final fields for immutability
/// 3. Use Freezed for value equality comparison and copyWith
/// 
/// EXAMPLE - Adding properties:
/// ```dart
/// @freezed
/// abstract class {{feature_name.pascalCase()}}Entity with _${{feature_name.pascalCase()}}Entity {
///   const {{feature_name.pascalCase()}}Entity._();
///
///   const factory {{feature_name.pascalCase()}}Entity({
///     required String id,
///     required String name,
///     required DateTime createdAt,
///     @Default(true) bool isActive,
///   }) = _[{{feature_name.pascalCase()}}Entity;
/// }
/// ```
/// 
/// BEST PRACTICES:
/// - Keep entities simple and focused on a single concept
/// - Use value objects for complex properties (e.g., Email, Money)
/// - Entities should be serialization-agnostic (no toJson/fromJson)
/// ============================================================================

@freezed
abstract class {{feature_name.pascalCase()}}Entity with _${{feature_name.pascalCase()}}Entity {
  const {{feature_name.pascalCase()}}Entity._();

  const factory {{feature_name.pascalCase()}}Entity({
    // TODO: Add entity properties
    // @Default('') String id,
    // @Default('') String name,
  }) = _{{feature_name.pascalCase()}}Entity;
}
