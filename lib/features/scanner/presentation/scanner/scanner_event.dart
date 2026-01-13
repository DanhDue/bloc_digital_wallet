// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Events for Scanner feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class ScannerEvent extends BaseEvent {
  const ScannerEvent();
}

/// Show success message (Toast/Snackbar)
class ShowSuccessMessage extends ScannerEvent {
  final String message;

  const ShowSuccessMessage(this.message);
}

/// Show error message (Toast/Snackbar)
class ShowErrorMessage extends ScannerEvent {
  final String message;

  const ShowErrorMessage(this.message);
}

/// Navigate to detail page
class NavigateToScannerDetail extends ScannerEvent {
  final String id;

  const NavigateToScannerDetail(this.id);
}

/// Navigate back
class NavigateBack extends ScannerEvent {
  const NavigateBack();
}
