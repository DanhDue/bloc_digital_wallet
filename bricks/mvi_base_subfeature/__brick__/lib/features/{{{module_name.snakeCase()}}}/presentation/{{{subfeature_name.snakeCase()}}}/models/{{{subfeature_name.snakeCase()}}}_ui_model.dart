// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

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
/// class {{subfeature_name.pascalCase()}}UiModel {
///   final String id;
///   final String displayName;
///   final String formattedDate;
///   
///   const {{subfeature_name.pascalCase()}}UiModel({
///     required this.id,
///     required this.displayName,
///     required this.formattedDate,
///   });
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

class {{subfeature_name.pascalCase()}}UiModel {
  const {{subfeature_name.pascalCase()}}UiModel();
  
  // TODO: Add UI-specific fields and factory constructors
}
