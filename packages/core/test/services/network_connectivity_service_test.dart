// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/services/network_connectivity_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

abstract class _InternetCheckerProxy {
  Future<bool> hasInternetAccess();
}

class _MockInternetChecker extends Mock implements _InternetCheckerProxy {}

void main() {
  group('NetworkConnectivityService Hybrid Reachability Tests', () {
    late _MockConnectivity mockConnectivity;
    late _MockInternetChecker mockInternetChecker;
    late StreamController<List<ConnectivityResult>> connectivityController;
    late NetworkConnectivityService service;

    setUp(() {
      mockConnectivity = _MockConnectivity();
      mockInternetChecker = _MockInternetChecker();
      connectivityController = StreamController<List<ConnectivityResult>>.broadcast();

      when(
        () => mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => connectivityController.stream);

      service = NetworkConnectivityService(
        connectivity: mockConnectivity,
        checkInternetAccess: mockInternetChecker.hasInternetAccess,
        debounceDuration: Duration.zero,
      );
    });

    tearDown(() async {
      await connectivityController.close();
      service.dispose();
    });

    test(
      'BDD-NET-01: emits online when interface available and internet probe succeeds',
      () async {
        when(() => mockInternetChecker.hasInternetAccess()).thenAnswer((_) async => true);

        final statuses = <NetworkStatus>[];
        final subscription = service.onStatusChanged.listen(statuses.add);

        connectivityController.add([ConnectivityResult.wifi]);
        await Future<void>.delayed(Duration.zero);

        expect(statuses, contains(NetworkStatus.online));
        expect(await service.isConnected, isTrue);

        await subscription.cancel();
      },
    );

    test(
      'BDD-NET-02: emits offline when interface is wifi but internet probe fails (Captive Portal Immunity)',
      () async {
        when(() => mockInternetChecker.hasInternetAccess()).thenAnswer((_) async => false);

        final statuses = <NetworkStatus>[];
        final subscription = service.onStatusChanged.listen(statuses.add);

        connectivityController.add([ConnectivityResult.wifi]);
        await Future<void>.delayed(Duration.zero);

        expect(statuses, contains(NetworkStatus.offline));
        expect(await service.isConnected, isFalse);

        await subscription.cancel();
      },
    );

    test('BDD-NET-03: immediately emits offline when interface is none without probe', () async {
      final statuses = <NetworkStatus>[];
      final subscription = service.onStatusChanged.listen(statuses.add);

      connectivityController.add([ConnectivityResult.none]);
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(NetworkStatus.offline));
      // Probing is skipped on hardware disconnect
      verifyNever(() => mockInternetChecker.hasInternetAccess());

      await subscription.cancel();
    });

    test('BDD-NET-06: debounces rapid flapping and settles on final verified state', () async {
      when(() => mockInternetChecker.hasInternetAccess()).thenAnswer((_) async => true);

      final debouncedService = NetworkConnectivityService(
        connectivity: mockConnectivity,
        checkInternetAccess: mockInternetChecker.hasInternetAccess,
        debounceDuration: const Duration(milliseconds: 50),
      );

      final statuses = <NetworkStatus>[];
      final subscription = debouncedService.onStatusChanged.listen(statuses.add);

      // Flapping 5 times rapidly
      connectivityController.add([ConnectivityResult.wifi]);
      connectivityController.add([ConnectivityResult.none]);
      connectivityController.add([ConnectivityResult.mobile]);
      connectivityController.add([ConnectivityResult.none]);
      connectivityController.add([ConnectivityResult.wifi]);

      // Before debounce settles
      expect(statuses, isEmpty);

      // After debounce settles
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(statuses, isNotEmpty);
      expect(statuses.last, NetworkStatus.online);

      await subscription.cancel();
      debouncedService.dispose();
    });
  });
}
