// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/deep_link_routes.dart';
import 'package:flutter/foundation.dart';

/// Immutable representation of a parsed and normalized deep link.
@immutable
class DeepLinkPayload {
  /// Normalized route path (e.g. `/scanner`, `/settings/languages`, `/home`).
  final String path;

  /// Parsed query parameters from the URI.
  final Map<String, String> queryParams;

  /// Target shell bottom navigation bar tab index, if applicable.
  /// 0: Home, 1: Scanner, 2: Settings, null: not a root tab screen.
  final int? targetTab;

  /// Whether navigating to this route requires user authentication.
  final bool isProtected;

  /// Indicates if this payload was generated as a fallback for an invalid or unknown URI.
  final bool isFallback;

  const DeepLinkPayload({
    required this.path,
    this.queryParams = const {},
    this.targetTab,
    this.isProtected = false,
    this.isFallback = false,
  });

  /// Creates a safe fallback payload pointing to the home landing tab.
  factory DeepLinkPayload.fallback({
    String path = DeepLinkRoutes.home,
    int? targetTab = 0,
    bool isProtected = false,
  }) {
    return DeepLinkPayload(
      path: path,
      targetTab: targetTab,
      isProtected: isProtected,
      isFallback: true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeepLinkPayload &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          mapEquals(queryParams, other.queryParams) &&
          targetTab == other.targetTab &&
          isProtected == other.isProtected &&
          isFallback == other.isFallback;

  @override
  int get hashCode =>
      path.hashCode ^
      Object.hashAll(queryParams.entries) ^
      targetTab.hashCode ^
      isProtected.hashCode ^
      isFallback.hashCode;

  @override
  String toString() =>
      'DeepLinkPayload(path: $path, queryParams: $queryParams, targetTab: $targetTab, isProtected: $isProtected, isFallback: $isFallback)';
}
