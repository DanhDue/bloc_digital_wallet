// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:app_platform/platform.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAppLinks implements AppLinks {
  Uri? initialLinkToReturn;
  final _uriStreamController = StreamController<Uri>.broadcast();

  @override
  Future<Uri?> getInitialLink() async => initialLinkToReturn;

  @override
  Future<String?> getInitialLinkString() async => initialLinkToReturn?.toString();

  @override
  Future<Uri?> getLatestLink() async => initialLinkToReturn;

  @override
  Future<String?> getLatestLinkString() async => initialLinkToReturn?.toString();

  @override
  Stream<Uri> get uriLinkStream => _uriStreamController.stream;

  @override
  Stream<String> get stringLinkStream => _uriStreamController.stream.map((u) => u.toString());

  void emitUri(Uri uri) {
    _uriStreamController.add(uri);
  }

  void dispose() {
    _uriStreamController.close();
  }
}

void main() {
  group('DeepLinkCoordinator', () {
    late _FakeAppLinks fakeAppLinks;
    late DeepLinkCoordinator coordinator;
    late List<DeepLinkPayload> dispatchedPayloads;

    setUp(() {
      DeepLinkRegistry.reset();
      fakeAppLinks = _FakeAppLinks();
      dispatchedPayloads = [];

      coordinator = DeepLinkCoordinator(
        appLinks: fakeAppLinks,
        parser: const DeepLinkParser(),
        onNavigate: (payload) {
          dispatchedPayloads.add(payload);
        },
      );
    });

    tearDown(() {
      coordinator.dispose();
      fakeAppLinks.dispose();
      DeepLinkRegistry.reset();
    });

    test('Cold Start: Stages initial link until markRouterReady is called', () async {
      fakeAppLinks.initialLinkToReturn = Uri.parse('d3nexus://scanner');

      await coordinator.initialize();

      // Should not dispatch before router is marked ready
      expect(coordinator.isRouterReady, isFalse);
      expect(dispatchedPayloads, isEmpty);
      expect(coordinator.stagedInitialLink, Uri.parse('d3nexus://scanner'));

      // When router becomes ready
      coordinator.markRouterReady();

      expect(coordinator.isRouterReady, isTrue);
      expect(dispatchedPayloads, hasLength(1));
      expect(dispatchedPayloads.single.path, DeepLinkRoutes.scanner);
      expect(dispatchedPayloads.single.targetTab, 1);
      expect(coordinator.stagedInitialLink, isNull);
    });

    test(
      'Cold Start: If router is already ready when initialize runs, dispatches immediately',
      () async {
        fakeAppLinks.initialLinkToReturn = Uri.parse('d3nexus://settings');

        coordinator.markRouterReady();
        await coordinator.initialize();

        expect(dispatchedPayloads, hasLength(1));
        expect(dispatchedPayloads.single.path, DeepLinkRoutes.settings);
        expect(dispatchedPayloads.single.targetTab, 2);
      },
    );

    test('Warm Start: Dispatches stream event when router is ready', () async {
      coordinator.markRouterReady();
      await coordinator.initialize();

      fakeAppLinks.emitUri(Uri.parse('d3nexus://scanner?auto_scan=true'));
      await Future<void>.delayed(Duration.zero);

      expect(dispatchedPayloads, hasLength(1));
      expect(dispatchedPayloads.single.path, DeepLinkRoutes.scanner);
      expect(dispatchedPayloads.single.queryParams['auto_scan'], 'true');
    });

    test(
      'Deduplication: Drops identical URI received within deduplication window (<1000ms)',
      () async {
        coordinator.markRouterReady();
        await coordinator.initialize();

        final uri = Uri.parse('d3nexus://scanner');
        fakeAppLinks.emitUri(uri);
        await Future<void>.delayed(Duration.zero);

        expect(dispatchedPayloads, hasLength(1));

        // Emit exact same URI again immediately
        fakeAppLinks.emitUri(uri);
        await Future<void>.delayed(Duration.zero);

        // Still 1, duplicate dropped
        expect(dispatchedPayloads, hasLength(1));
      },
    );

    test('Deduplication: Allows different URI even if received quickly', () async {
      coordinator.markRouterReady();
      await coordinator.initialize();

      fakeAppLinks.emitUri(Uri.parse('d3nexus://scanner'));
      await Future<void>.delayed(Duration.zero);
      expect(dispatchedPayloads, hasLength(1));

      fakeAppLinks.emitUri(Uri.parse('d3nexus://settings'));
      await Future<void>.delayed(Duration.zero);
      expect(dispatchedPayloads, hasLength(2));
      expect(dispatchedPayloads[0].path, DeepLinkRoutes.scanner);
      expect(dispatchedPayloads[1].path, DeepLinkRoutes.settings);
    });
  });
}
