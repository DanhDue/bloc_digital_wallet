// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// D3Votion Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend D3VotionEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToD3VotionDetailEvent extends D3VotionEvent {
///   final String id;
///   const NavigateToD3VotionDetailEvent(this.id);
/// }
///
/// class ShowD3VotionErrorEvent extends D3VotionEvent {
///   final String message;
///   const ShowD3VotionErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToD3VotionDetailEvent(id));
/// ```
/// ============================================================================

sealed class D3VotionEvent extends BaseEvent {
  const D3VotionEvent();
}
