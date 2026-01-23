// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Trends Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend TrendsEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToTrendsDetailEvent extends TrendsEvent {
///   final String id;
///   const NavigateToTrendsDetailEvent(this.id);
/// }
///
/// class ShowTrendsErrorEvent extends TrendsEvent {
///   final String message;
///   const ShowTrendsErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToTrendsDetailEvent(id));
/// ```
/// ============================================================================

sealed class TrendsEvent extends BaseEvent {
  const TrendsEvent();
}
