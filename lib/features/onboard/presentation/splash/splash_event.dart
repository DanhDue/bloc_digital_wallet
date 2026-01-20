// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/architecture/architecture.dart';

/// ============================================================================
/// Splash Events
/// ============================================================================

sealed class SplashEvent extends BaseEvent {
  const SplashEvent();
}

/// Event to navigate to the next screen after successful health check
class NavigateToNextEvent extends SplashEvent {
  const NavigateToNextEvent();
}

/// Event to show error message
class ShowErrorMessageEvent extends SplashEvent {
  final String message;
  const ShowErrorMessageEvent(this.message);
}
