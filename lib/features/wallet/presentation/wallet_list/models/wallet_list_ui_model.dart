// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

/// ============================================================================
/// WalletList UI Model
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
/// class WalletListUiModel {
///   final String id;
///   final String displayName;
///   final String formattedDate;
///
///   const WalletListUiModel({
///     required this.id,
///     required this.displayName,
///     required this.formattedDate,
///   });
///
///   factory WalletListUiModel.fromEntity(YourEntity entity) {
///     return WalletListUiModel(
///       id: entity.id,
///       displayName: entity.name.toUpperCase(),
///       formattedDate: DateFormat.yMd().format(entity.createdAt),
///     );
///   }
/// }
/// ```
/// ============================================================================

class WalletListUiModel {
  const WalletListUiModel();

  // TODO: Add UI-specific fields and factory constructors
}
