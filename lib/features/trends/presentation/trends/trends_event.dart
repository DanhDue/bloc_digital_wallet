// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Events for Trends feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class TrendsEvent extends BaseEvent {
  const TrendsEvent();
}

/// Show success message (Toast/Snackbar)
class ShowSuccessMessage extends TrendsEvent {
  final String message;

  const ShowSuccessMessage(this.message);
}

/// Show error message (Toast/Snackbar)
class ShowErrorMessage extends TrendsEvent {
  final String message;

  const ShowErrorMessage(this.message);
}

/// Navigate to detail page
class NavigateToTrendsDetail extends TrendsEvent {
  final String id;

  const NavigateToTrendsDetail(this.id);
}

/// Navigate back
class NavigateBack extends TrendsEvent {
  const NavigateBack();
}
