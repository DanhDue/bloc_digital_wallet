// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Message types for ShowMessage event
enum MessageType { success, error, info }

/// Events for Settings feature (OUTPUT: ViewModel → View)
sealed class SettingsEvent extends BaseEvent {
  const SettingsEvent();
}

/// Show message (Toast/Snackbar)
class ShowMessage extends SettingsEvent {
  final String message;
  final MessageType type;

  const ShowMessage(this.message, {this.type = MessageType.info});
  const ShowMessage.success(this.message) : type = MessageType.success;
  const ShowMessage.error(this.message) : type = MessageType.error;
}

class NavigateToProfileEvent extends SettingsEvent {
  const NavigateToProfileEvent();
}
