// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Scanner Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
///
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend ScannerAction
/// 3. Include any data needed to process the action
///
/// EXAMPLE - Adding actions:
/// ```dart
/// class LoadScannerAction extends ScannerAction {
///   const LoadScannerAction();
/// }
///
/// class SubmitScannerAction extends ScannerAction {
///   final String data;
///   const SubmitScannerAction(this.data);
/// }
///
/// class RefreshScannerAction extends ScannerAction {
///   const RefreshScannerAction();
/// }
/// ```
/// ============================================================================

sealed class ScannerAction extends BaseAction {
  const ScannerAction();
}

/// Initialize action - called when the feature starts
class InitScannerAction extends ScannerAction {
  const InitScannerAction();
}
