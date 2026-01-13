// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Scanner feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class ScannerAction extends BaseAction {
  const ScannerAction();
}

/// Load all scanners
class LoadAllScannersAction extends ScannerAction {
  const LoadAllScannersAction();
}

/// Load single scanner
class LoadScannerAction extends ScannerAction {
  final String id;

  const LoadScannerAction(this.id);
}

/// Create scanner
class CreateScannerAction extends ScannerAction {
  final String name;
  // TODO: Add parameters

  const CreateScannerAction({required this.name});
}

/// Update scanner
class UpdateScannerAction extends ScannerAction {
  final String id;
  final String name;
  // TODO: Add parameters

  const UpdateScannerAction({required this.id, required this.name});
}

/// Delete scanner
class DeleteScannerAction extends ScannerAction {
  final String id;

  const DeleteScannerAction(this.id);
}

/// Refresh scanners
class RefreshScannersAction extends ScannerAction {
  const RefreshScannersAction();
}
