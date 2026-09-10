// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:app_platform/platform.dart';

/// Central guard evaluating whether an incoming deep link can be dispatched immediately
/// or must be buffered while an authentication challenge is completed.
class DeepLinkAuthGuard {
  final AppEventBus _eventBus;
  final bool Function() _isAuthenticated;
  final void Function() _onRequireLogin;

  DeepLinkPayload? _pendingPayload;
  void Function(DeepLinkPayload)? _pendingCallback;
  StreamSubscription<LoginSuccessEvent>? _loginSub;
  StreamSubscription<UserLoggedOut>? _logoutSub;

  DeepLinkAuthGuard({
    required AppEventBus eventBus,
    required bool Function() isAuthenticated,
    required void Function() onRequireLogin,
  }) : _eventBus = eventBus,
       _isAuthenticated = isAuthenticated,
       _onRequireLogin = onRequireLogin {
    _initSubscriptions();
  }

  void _initSubscriptions() {
    _loginSub = _eventBus.on<LoginSuccessEvent>().listen((_) {
      _resumePendingPayload();
    });

    _logoutSub = _eventBus.on<UserLoggedOut>().listen((_) {
      clearPendingPayload();
    });
  }

  /// Currently pending deep link payload waiting for authentication.
  DeepLinkPayload? get pendingPayload => _pendingPayload;

  /// Evaluates an incoming [payload].
  /// If the route is public or the user is already authenticated, invokes [onAllowed].
  /// Otherwise, buffers [payload] and triggers [_onRequireLogin].
  void evaluate(DeepLinkPayload payload, {required void Function(DeepLinkPayload) onAllowed}) {
    if (!payload.isProtected || _isAuthenticated()) {
      onAllowed(payload);
      return;
    }

    _pendingPayload = payload;
    _pendingCallback = onAllowed;
    _onRequireLogin();
  }

  /// Resumes and dispatches the pending payload after a successful login.
  void _resumePendingPayload() {
    if (_pendingPayload != null && _pendingCallback != null) {
      final payload = _pendingPayload!;
      final callback = _pendingCallback!;
      clearPendingPayload();
      callback(payload);
    }
  }

  /// Clears any cached pending payload.
  void clearPendingPayload() {
    _pendingPayload = null;
    _pendingCallback = null;
  }

  /// Disposes internal subscriptions.
  void dispose() {
    _loginSub?.cancel();
    _logoutSub?.cancel();
    clearPendingPayload();
  }
}
