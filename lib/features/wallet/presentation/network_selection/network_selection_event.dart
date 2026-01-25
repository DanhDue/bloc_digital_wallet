// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// NetworkSelection Events
/// ============================================================================
/// Events are one-time occurrences (navigation, snackbar, dialog).
/// Unlike states, events are consumed once and don't persist.
///
/// HOW TO EXTEND:
/// 1. Add new event classes for different one-time actions
/// 2. Each event should extend NetworkSelectionEvent
/// 3. Handle events in the page's event listener
/// ============================================================================

sealed class NetworkSelectionEvent extends BaseEvent {
  const NetworkSelectionEvent();
}

/// Message types for showing feedback to user
enum MessageType { success, error, info }

/// Event to show a message (snackbar/toast)
class ShowMessage extends NetworkSelectionEvent {
  final String message;
  final MessageType type;

  const ShowMessage(this.message, {this.type = MessageType.info});
  const ShowMessage.success(this.message) : type = MessageType.success;
  const ShowMessage.error(this.message) : type = MessageType.error;
}
