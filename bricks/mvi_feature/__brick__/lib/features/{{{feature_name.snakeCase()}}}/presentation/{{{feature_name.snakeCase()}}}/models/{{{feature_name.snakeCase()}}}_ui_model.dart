// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{feature_name.snakeCase()}}_ui_model.freezed.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} UI Model
/// ============================================================================
/// UI Models are presentation-layer representations of data.
/// They should contain only the data needed for displaying in the UI.
/// 
/// HOW TO EXTEND:
/// 1. Add fields needed for UI display
/// 2. Add factory constructors to convert from entities
/// 3. Keep this model focused on presentation concerns
/// 
/// EXAMPLE:
/// ```dart
/// @freezed
/// abstract class {{feature_name.pascalCase()}}UiModel with _${{feature_name.pascalCase()}}UiModel {
///   const {{feature_name.pascalCase()}}UiModel._();
///
///   const factory {{feature_name.pascalCase()}}UiModel({
///     required String id,
///     required String displayName,
///     required String formattedDate,
///   }) = _{{feature_name.pascalCase()}}UiModel;
///   
///   factory {{feature_name.pascalCase()}}UiModel.fromEntity({{feature_name.pascalCase()}}Entity entity) {
///     return {{feature_name.pascalCase()}}UiModel(
///       id: entity.id,
///       displayName: entity.name.toUpperCase(),
///       formattedDate: DateFormat.yMd().format(entity.createdAt),
///     );
///   }
/// }
/// ```
/// ============================================================================

@freezed
abstract class {{feature_name.pascalCase()}}UiModel with _${{feature_name.pascalCase()}}UiModel {
  const {{feature_name.pascalCase()}}UiModel._();

  const factory {{feature_name.pascalCase()}}UiModel({
    // TODO: Replace this placeholder with actual UI-specific fields
    // Example:
    // required String id,
    // required String displayName,
    @Default('') String id,
  }) = _{{feature_name.pascalCase()}}UiModel;
}
