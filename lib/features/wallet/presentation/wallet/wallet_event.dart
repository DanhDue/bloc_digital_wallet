// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Events for Wallet feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class WalletEvent extends BaseEvent {
  const WalletEvent();
}

/// Show success message (Toast/Snackbar)
class ShowSuccessMessage extends WalletEvent {
  final String message;

  const ShowSuccessMessage(this.message);
}

/// Show error message (Toast/Snackbar)
class ShowErrorMessage extends WalletEvent {
  final String message;

  const ShowErrorMessage(this.message);
}

/// Navigate to detail page
class NavigateToWalletDetail extends WalletEvent {
  final String id;

  const NavigateToWalletDetail(this.id);
}

/// Navigate back
class NavigateBack extends WalletEvent {
  const NavigateBack();
}
