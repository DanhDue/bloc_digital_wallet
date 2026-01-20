// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Onboard Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend OnboardEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToOnboardDetailEvent extends OnboardEvent {
///   final String id;
///   const NavigateToOnboardDetailEvent(this.id);
/// }
///
/// class ShowOnboardErrorEvent extends OnboardEvent {
///   final String message;
///   const ShowOnboardErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToOnboardDetailEvent(id));
/// ```
/// ============================================================================

sealed class OnboardEvent extends BaseEvent {
  const OnboardEvent();
}
