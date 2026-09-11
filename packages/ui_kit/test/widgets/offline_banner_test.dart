// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:core/services/network_connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/widgets/offline_banner.dart';

void main() {
  group('OfflineBanner & OfflineBannerWrapper BDD Tests', () {
    testWidgets('BDD-NET-04: OfflineBanner renders with offline icon and warning message', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OfflineBanner(message: 'Không có kết nối mạng')),
        ),
      );

      expect(find.text('Không có kết nối mạng'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });

    testWidgets(
      'BDD-NET-04 & BDD-NET-05: OfflineBannerWrapper slides in on offline and auto-dismisses on online',
      (tester) async {
        final statusController = StreamController<NetworkStatus>.broadcast();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OfflineBannerWrapper(
                statusStream: statusController.stream,
                child: const Center(child: Text('Main Screen Content')),
              ),
            ),
          ),
        );

        // Initially online / normal screen
        expect(find.text('Main Screen Content'), findsOneWidget);
        expect(find.text('Không có kết nối mạng'), findsNothing);

        // Network drops -> emits offline
        statusController.add(NetworkStatus.offline);
        await tester.pumpAndSettle();

        expect(find.text('Không có kết nối mạng'), findsOneWidget);
        expect(find.text('Main Screen Content'), findsOneWidget);

        // Network recovers -> emits online
        statusController.add(NetworkStatus.online);
        await tester.pumpAndSettle();

        // Banner dismissed
        expect(find.text('Không có kết nối mạng'), findsNothing);
        expect(find.text('Main Screen Content'), findsOneWidget);

        await statusController.close();
      },
    );
  });
}
