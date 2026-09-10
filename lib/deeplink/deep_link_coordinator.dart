// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:app_platform/platform.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_auth_guard.dart';

/// Central coordinator managing deep-link reception lifecycle, timing gates,
/// deduplication, and routing delegation.
class DeepLinkCoordinator {
  final AppLinks _appLinks;
  final DeepLinkParser _parser;
  final void Function(DeepLinkPayload) _onNavigate;
  final DeepLinkAuthGuard? _authGuard;

  bool _isRouterReady = false;
  Uri? _stagedInitialLink;
  Uri? _lastProcessedUri;
  DateTime? _lastProcessedTime;
  StreamSubscription<Uri>? _uriSubscription;

  /// Deduplication threshold: ignores duplicate URIs received within 1000ms.
  static const int deduplicationThresholdMs = 1000;

  DeepLinkCoordinator({
    required AppLinks appLinks,
    DeepLinkParser parser = const DeepLinkParser(),
    required void Function(DeepLinkPayload) onNavigate,
    DeepLinkAuthGuard? authGuard,
  }) : _appLinks = appLinks,
       _parser = parser,
       _onNavigate = onNavigate,
       _authGuard = authGuard;

  /// Whether the UI router context has finished mounting and is ready to execute navigations.
  bool get isRouterReady => _isRouterReady;

  /// Buffered initial link received during cold start before router ready.
  Uri? get stagedInitialLink => _stagedInitialLink;

  /// Initializes deep-link listening for cold start and incoming warm streams.
  Future<void> initialize() async {
    // 1. Cold Start handling
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        if (!_isRouterReady) {
          _stagedInitialLink = initialUri;
        } else {
          handleUri(initialUri);
        }
      }
    } catch (_) {
      // Ignore initial link retrieval failures gracefully
    }

    // 2. Warm Start stream handling
    _uriSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        handleUri(uri);
      },
      onError: (_) {
        // Stream errors are non-fatal
      },
    );
  }

  /// Signals that the UI router context (ShellPage) has rendered its first frame
  /// and is safe to execute navigations.
  void markRouterReady() {
    _isRouterReady = true;

    if (_stagedInitialLink != null) {
      final stagedUri = _stagedInitialLink!;
      _stagedInitialLink = null;
      handleUri(stagedUri);
    }
  }

  /// Normalizes, deduplicates, parses, and dispatches an incoming [uri].
  void handleUri(Uri uri) {
    // Deduplication check
    final now = DateTime.now();
    if (_lastProcessedUri == uri && _lastProcessedTime != null) {
      final diff = now.difference(_lastProcessedTime!).inMilliseconds;
      if (diff < deduplicationThresholdMs) {
        return;
      }
    }

    _lastProcessedUri = uri;
    _lastProcessedTime = now;

    final payload = _parser.parse(uri);

    if (_authGuard != null) {
      _authGuard.evaluate(
        payload,
        onAllowed: (allowedPayload) {
          _onNavigate(allowedPayload);
        },
      );
    } else {
      _onNavigate(payload);
    }
  }

  /// Cleans up subscriptions and state.
  void dispose() {
    _uriSubscription?.cancel();
    _uriSubscription = null;
    _stagedInitialLink = null;
    _lastProcessedUri = null;
  }
}
