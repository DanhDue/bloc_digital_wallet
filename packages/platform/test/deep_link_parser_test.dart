// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/deep_link_parser.dart';
import 'package:app_platform/deep_link_registry.dart';
import 'package:app_platform/deep_link_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeepLinkParser', () {
    late DeepLinkParser parser;

    setUp(() {
      DeepLinkRegistry.reset();
      parser = const DeepLinkParser();
    });

    tearDown(() {
      DeepLinkRegistry.reset();
    });

    group('Custom URL Scheme (d3nexus://)', () {
      test('parses custom scheme root tab (d3nexus://scanner)', () {
        final uri = Uri.parse('d3nexus://scanner');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.scanner);
        expect(payload.targetTab, 1);
        expect(payload.queryParams, isEmpty);
        expect(payload.isProtected, isFalse);
        expect(payload.isFallback, isFalse);
      });

      test('parses custom scheme with path format (d3nexus:///settings)', () {
        final uri = Uri.parse('d3nexus:///settings');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.settings);
        expect(payload.targetTab, 2);
        expect(payload.isFallback, isFalse);
      });

      test('parses custom scheme with query parameters', () {
        final uri = Uri.parse('d3nexus://scanner?auto_scan=true&filter=qr');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.scanner);
        expect(payload.targetTab, 1);
        expect(payload.queryParams, {'auto_scan': 'true', 'filter': 'qr'});
      });

      test('parses custom scheme with sub-path (d3nexus://settings/languages)', () {
        // Register sub-path in registry
        DeepLinkRegistry.registerRoute(path: '/settings/languages', targetTab: 2);

        final uri = Uri.parse('d3nexus://settings/languages');
        final payload = parser.parse(uri);

        expect(payload.path, '/settings/languages');
        expect(payload.targetTab, 2);
        expect(payload.isFallback, isFalse);
      });

      test('normalizes trailing slash and uppercase scheme (D3NEXUS://HOME/)', () {
        final uri = Uri.parse('D3NEXUS://HOME/');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.home);
        expect(payload.targetTab, 0);
        expect(payload.isFallback, isFalse);
      });
    });

    group('Universal / App Links (https://app.d3nexus.com)', () {
      test('parses https universal link for settings tab', () {
        final uri = Uri.parse('https://app.d3nexus.com/settings');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.settings);
        expect(payload.targetTab, 2);
        expect(payload.isFallback, isFalse);
      });

      test('parses https universal link with query params', () {
        final uri = Uri.parse('https://app.d3nexus.com/home?campaign=welcome&src=email');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.home);
        expect(payload.targetTab, 0);
        expect(payload.queryParams, {'campaign': 'welcome', 'src': 'email'});
      });
    });

    group('Protected Routes', () {
      test('identifies protected route from registry', () {
        final uri = Uri.parse('d3nexus://wallet');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.wallet);
        expect(payload.isProtected, isTrue);
      });
    });

    group('Fallback & Error Handling', () {
      test('returns fallback payload on unknown path', () {
        final uri = Uri.parse('d3nexus://non_existent_screen');
        final payload = parser.parse(uri);

        expect(payload.isFallback, isTrue);
        expect(payload.path, DeepLinkRoutes.home);
        expect(payload.targetTab, 0);
      });

      test('returns fallback payload on empty scheme/path', () {
        final uri = Uri.parse('d3nexus://');
        final payload = parser.parse(uri);

        expect(payload.path, DeepLinkRoutes.home);
        expect(payload.targetTab, 0);
        expect(payload.isFallback, isFalse); // Root path resolves to home
      });
    });

    group('DeepLinkRegistry Dynamic Registration', () {
      test('allows dynamic route registration and resolution', () {
        DeepLinkRegistry.registerRoute(
          path: '/payment/checkout',
          targetTab: null,
          isProtected: true,
        );

        expect(DeepLinkRegistry.isKnownRoute('/payment/checkout'), isTrue);
        expect(DeepLinkRegistry.isProtected('/payment/checkout'), isTrue);

        final uri = Uri.parse('d3nexus://payment/checkout?amount=500');
        final payload = parser.parse(uri);

        expect(payload.path, '/payment/checkout');
        expect(payload.targetTab, isNull);
        expect(payload.isProtected, isTrue);
        expect(payload.queryParams, {'amount': '500'});
        expect(payload.isFallback, isFalse);
      });
    });
  });
}
