// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Events for Transaction feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class TransactionEvent extends BaseEvent {
  const TransactionEvent();
}

/// Show success message (Toast/Snackbar)
class ShowSuccessMessage extends TransactionEvent {
  final String message;

  const ShowSuccessMessage(this.message);
}

/// Show error message (Toast/Snackbar)
class ShowErrorMessage extends TransactionEvent {
  final String message;

  const ShowErrorMessage(this.message);
}

/// Navigate to detail page
class NavigateToTransactionDetail extends TransactionEvent {
  final String id;

  const NavigateToTransactionDetail(this.id);
}

/// Navigate back
class NavigateBack extends TransactionEvent {
  const NavigateBack();
}
