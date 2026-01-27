// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part '{{subfeature_name.snakeCase()}}_ui_model.freezed.dart';

/// ============================================================================
/// {{subfeature_name.pascalCase()}} UI Model
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
/// abstract class {{subfeature_name.pascalCase()}}UiModel with _${{subfeature_name.pascalCase()}}UiModel {
///   const {{subfeature_name.pascalCase()}}UiModel._();
///
///   const factory {{subfeature_name.pascalCase()}}UiModel({
///     required String id,
///     required String displayName,
///     required String formattedDate,
///   }) = _{{subfeature_name.pascalCase()}}UiModel;
///   
///   factory {{subfeature_name.pascalCase()}}UiModel.fromEntity(YourEntity entity) {
///     return {{subfeature_name.pascalCase()}}UiModel(
///       id: entity.id,
///       displayName: entity.name.toUpperCase(),
///       formattedDate: DateFormat.yMd().format(entity.createdAt),
///     );
///   }
/// }
/// ```
/// ============================================================================

@freezed
abstract class {{subfeature_name.pascalCase()}}UiModel with _${{subfeature_name.pascalCase()}}UiModel {
  const {{subfeature_name.pascalCase()}}UiModel._();

  const factory {{subfeature_name.pascalCase()}}UiModel({
    // TODO: Add UI-specific fields
    // required String id,
  }) = _{{subfeature_name.pascalCase()}}UiModel;
}
