// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Scanner Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend ScannerEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToScannerDetailEvent extends ScannerEvent {
///   final String id;
///   const NavigateToScannerDetailEvent(this.id);
/// }
///
/// class ShowScannerErrorEvent extends ScannerEvent {
///   final String message;
///   const ShowScannerErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToScannerDetailEvent(id));
/// ```
/// ============================================================================

sealed class ScannerEvent extends BaseEvent {
  const ScannerEvent();
}
