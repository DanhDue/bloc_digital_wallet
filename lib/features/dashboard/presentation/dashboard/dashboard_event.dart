// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Dashboard Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend DashboardEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToDashboardDetailEvent extends DashboardEvent {
///   final String id;
///   const NavigateToDashboardDetailEvent(this.id);
/// }
///
/// class ShowDashboardErrorEvent extends DashboardEvent {
///   final String message;
///   const ShowDashboardErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToDashboardDetailEvent(id));
/// ```
/// ============================================================================

sealed class DashboardEvent extends BaseEvent {
  const DashboardEvent();
}
