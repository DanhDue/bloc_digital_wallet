// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// Wallet Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
///
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend WalletEvent
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
///
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateToWalletDetailEvent extends WalletEvent {
///   final String id;
///   const NavigateToWalletDetailEvent(this.id);
/// }
///
/// class ShowWalletErrorEvent extends WalletEvent {
///   final String message;
///   const ShowWalletErrorEvent(this.message);
/// }
/// ```
///
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateToWalletDetailEvent(id));
/// ```
/// ============================================================================

sealed class WalletEvent extends BaseEvent {
  const WalletEvent();
}
