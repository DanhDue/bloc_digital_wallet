// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/deeplink/deep_link_payload.dart';
import 'package:app_platform/deeplink/deep_link_registry.dart';
import 'package:app_platform/deeplink/deep_link_routes.dart';

/// Pure Dart parser for normalizing OS-level URIs into structured DeepLinkPayloads.
class DeepLinkParser {
  const DeepLinkParser();

  /// Supported custom URL schemes.
  static const Set<String> supportedSchemes = {'d3nexus', 'd3nexusshield'};

  /// Supported HTTP hosts for Universal/App Links.
  static const Set<String> supportedHosts = {'app.d3nexus.com', 'd3nexus.com'};

  /// Parses a raw [Uri] into a strongly-typed [DeepLinkPayload].
  DeepLinkPayload parse(Uri uri) {
    try {
      final scheme = uri.scheme.toLowerCase();
      final host = uri.host.toLowerCase();
      String rawPath = uri.path;

      if (supportedSchemes.contains(scheme)) {
        // Custom Scheme handling:
        // In d3nexus://scanner, RFC 3986 treats 'scanner' as host, uri.path as empty.
        // In d3nexus:///scanner, host is empty, uri.path is '/scanner'.
        if (host.isNotEmpty) {
          if (supportedHosts.contains(host)) {
            rawPath = uri.path;
          } else {
            rawPath = '/$host${uri.path}';
          }
        }
      } else if (scheme == 'http' || scheme == 'https') {
        // Universal Links / App Links handling
        rawPath = uri.path;
      }

      final normalizedPath = _normalizePath(rawPath);

      // Extract query parameters
      final queryParams = Map<String, String>.from(uri.queryParameters);

      // Resolve from registry
      final registration = DeepLinkRegistry.resolve(normalizedPath);
      if (registration != null || DeepLinkRegistry.isKnownRoute(normalizedPath)) {
        return DeepLinkPayload(
          path: normalizedPath,
          queryParams: queryParams,
          targetTab: registration?.targetTab,
          isProtected: registration?.isProtected ?? false,
          isFallback: false,
        );
      }

      // If route is unknown, return safe fallback
      return DeepLinkPayload.fallback(path: DeepLinkRoutes.home, targetTab: 0);
    } catch (_) {
      // Safe defensive fallback on any parsing failure
      return DeepLinkPayload.fallback(path: DeepLinkRoutes.home, targetTab: 0);
    }
  }

  /// Normalizes a path string: ensures leading slash, removes trailing slash, defaults empty to /home.
  String _normalizePath(String rawPath) {
    var p = rawPath.trim().toLowerCase();
    if (p.isEmpty || p == '/') {
      return DeepLinkRoutes.home;
    }
    if (!p.startsWith('/')) {
      p = '/$p';
    }
    if (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }
}
