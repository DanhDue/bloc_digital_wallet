// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/main.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    configureDependencies();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Allow router to build initial route.
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
