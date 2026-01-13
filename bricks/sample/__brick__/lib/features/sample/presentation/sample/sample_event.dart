// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Message types for ShowMessage event
enum MessageType { success, error, info, warning }

/// Events for Sample feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class SampleEvent extends BaseEvent {
  const SampleEvent();
}

/// Show message (Toast/Snackbar) - unified for success, error, info, warning
class ShowMessage extends SampleEvent {
  final String message;
  final MessageType type;

  const ShowMessage(this.message, {this.type = MessageType.info});
  const ShowMessage.success(this.message) : type = MessageType.success;
  const ShowMessage.error(this.message) : type = MessageType.error;
  const ShowMessage.warning(this.message) : type = MessageType.warning;
}

/// Navigate to detail page
class NavigateToSampleDetail extends SampleEvent {
  final String id;
  const NavigateToSampleDetail(this.id);
}

/// Navigate to create page
class NavigateToCreateSample extends SampleEvent {
  const NavigateToCreateSample();
}

/// Navigate to edit page
class NavigateToEditSample extends SampleEvent {
  final String id;
  const NavigateToEditSample(this.id);
}

/// Navigate back
class NavigateBack extends SampleEvent {
  const NavigateBack();
}

/// Show confirmation dialog
class ShowConfirmDialog extends SampleEvent {
  final String title;
  final String message;
  const ShowConfirmDialog({required this.title, required this.message});
}
