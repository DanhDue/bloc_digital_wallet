// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Events for Home feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class HomeEvent extends BaseEvent {
  const HomeEvent();
}

/// Show success message (Toast/Snackbar)
class ShowSuccessMessage extends HomeEvent {
  final String message;

  const ShowSuccessMessage(this.message);
}

/// Show error message (Toast/Snackbar)
class ShowErrorMessage extends HomeEvent {
  final String message;

  const ShowErrorMessage(this.message);
}

/// Navigate to detail page
class NavigateToHomeDetail extends HomeEvent {
  final String id;

  const NavigateToHomeDetail(this.id);
}

/// Navigate back
class NavigateBack extends HomeEvent {
  const NavigateBack();
}
