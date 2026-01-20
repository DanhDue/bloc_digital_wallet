// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/architecture/architecture.dart';

/// ============================================================================
/// Splash Actions
/// ============================================================================

sealed class SplashAction extends BaseAction {
  const SplashAction();
}

/// Action to initialize and perform health check
class InitSplashAction extends SplashAction {
  const InitSplashAction();
}

/// Action to retry health check
class RetryHealthCheckAction extends SplashAction {
  const RetryHealthCheckAction();
}
