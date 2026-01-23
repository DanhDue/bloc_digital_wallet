// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Transaction Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend TransactionEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToTransactionDetailEvent extends TransactionEvent {
///   final String id;
///   const NavigateToTransactionDetailEvent(this.id);
/// }
///
/// class ShowTransactionErrorEvent extends TransactionEvent {
///   final String message;
///   const ShowTransactionErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToTransactionDetailEvent(id));
/// ```
/// ============================================================================

sealed class TransactionEvent extends BaseEvent {
  const TransactionEvent();
}
