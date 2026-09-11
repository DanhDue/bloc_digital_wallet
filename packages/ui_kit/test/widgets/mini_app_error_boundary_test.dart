// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/widgets/mini_app_error_boundary.dart';

class _ThrowingWidget extends StatelessWidget {
  const _ThrowingWidget({required this.shouldThrow, this.message = 'Simulated MiniApp Crash'});

  final bool shouldThrow;
  final String message;

  @override
  Widget build(BuildContext context) {
    if (shouldThrow) {
      throw Exception(message);
    }
    return const Text('Healthy Mini App Content');
  }
}

void main() {
  group('MiniAppErrorBoundary BDD & TDD Widget Tests', () {
    testWidgets('BDD-ERR-01: Healthy child renders directly without fallback UI', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MiniAppErrorBoundary(
              moduleName: 'Home',
              child: Text('Healthy Mini App Content'),
            ),
          ),
        ),
      );

      expect(find.text('Healthy Mini App Content'), findsOneWidget);
      expect(find.text('Tính năng Home tạm thời gián đoạn'), findsNothing);
      expect(find.text('Thử lại'), findsNothing);
      expect(find.text('Về Trang Chủ'), findsNothing);
    });

    testWidgets(
      'BDD-ERR-02: Throwing child triggers fallback UI with warning icon, title, and buttons',
      (tester) async {
        Object? caughtError;
        StackTrace? caughtStack;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MiniAppErrorBoundary(
                moduleName: 'Scanner',
                onError: (error, stack) {
                  caughtError = error;
                  caughtStack = stack;
                },
                child: const _ThrowingWidget(shouldThrow: true),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verifies fallback UI
        expect(find.text('Tính năng Scanner tạm thời gián đoạn'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
        expect(find.text('Thử lại'), findsOneWidget);
        expect(find.text('Về Trang Chủ'), findsOneWidget);

        // Verifies onError callback received error details
        expect(caughtError, isNotNull);
        expect(caughtError.toString(), contains('Simulated MiniApp Crash'));
        expect(caughtStack, isNotNull);
      },
    );

    testWidgets('BDD-ERR-03: Tapping "Thử lại" resets error state and rebuilds child', (
      tester,
    ) async {
      var shouldThrow = true;
      var retryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return MiniAppErrorBoundary(
                  moduleName: 'Settings',
                  onRetry: () {
                    retryTapped = true;
                    setState(() {
                      shouldThrow = false;
                    });
                  },
                  child: _ThrowingWidget(shouldThrow: shouldThrow),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tính năng Settings tạm thời gián đoạn'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);

      // Tap "Thử lại"
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();

      expect(retryTapped, isTrue);
      expect(find.text('Healthy Mini App Content'), findsOneWidget);
      expect(find.text('Tính năng Settings tạm thời gián đoạn'), findsNothing);
    });

    testWidgets('BDD-ERR-04: Tapping "Về Trang Chủ" invokes onGoHome callback', (tester) async {
      var goHomeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiniAppErrorBoundary(
              moduleName: 'Scanner',
              onGoHome: () {
                goHomeCalled = true;
              },
              child: const _ThrowingWidget(shouldThrow: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Về Trang Chủ'), findsOneWidget);

      await tester.tap(find.text('Về Trang Chủ'));
      await tester.pumpAndSettle();

      expect(goHomeCalled, isTrue);
    });

    testWidgets(
      'BDD-ERR-05: Debug Accordion is visible in devMode=true and omitted in devMode=false',
      (tester) async {
        // 1. In devMode: true -> accordion is present
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MiniAppErrorBoundary(
                moduleName: 'DebugModule',
                devMode: true,
                child: _ThrowingWidget(shouldThrow: true, message: 'CrashDetails123'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Chi tiết lỗi (Debug)'), findsOneWidget);

        // Tap the accordion to expand and view error message
        await tester.tap(find.text('Chi tiết lỗi (Debug)'));
        await tester.pumpAndSettle();
        expect(find.textContaining('CrashDetails123'), findsOneWidget);

        // 2. In devMode: false (release mode simulation) -> accordion is completely omitted
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MiniAppErrorBoundary(
                moduleName: 'ReleaseModule',
                devMode: false,
                child: _ThrowingWidget(shouldThrow: true, message: 'SecretInternalCrash'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Chi tiết lỗi (Debug)'), findsNothing);
        expect(find.textContaining('SecretInternalCrash'), findsNothing);
      },
    );
  });
}
