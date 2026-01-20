// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// {{subfeature_name.pascalCase()}} Events
/// ============================================================================
/// Events are one-time occurrences (navigation, snackbar, dialog).
/// Unlike states, events are consumed once and don't persist.
/// 
/// HOW TO EXTEND:
/// 1. Add new event classes for different one-time actions
/// 2. Each event should extend {{subfeature_name.pascalCase()}}Event
/// 3. Handle events in the page's event listener
/// ============================================================================

sealed class {{subfeature_name.pascalCase()}}Event extends BaseEvent {
  const {{subfeature_name.pascalCase()}}Event();
}

/// Message types for showing feedback to user
enum MessageType { success, error, info }

/// Event to show a message (snackbar/toast)
class ShowMessage extends {{subfeature_name.pascalCase()}}Event {
  final String message;
  final MessageType type;

  const ShowMessage(this.message, {this.type = MessageType.info});
  const ShowMessage.success(this.message) : type = MessageType.success;
  const ShowMessage.error(this.message) : type = MessageType.error;
}
