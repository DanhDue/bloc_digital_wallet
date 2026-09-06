// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLogManager extends Mock implements ILogManager {}
class MockLogger extends Mock implements ILogger {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final mockLogManager = MockLogManager();
    when(() => mockLogManager.getLogger(any())).thenReturn(MockLogger());
    try {
      D3NexusLogger.initialize(mockLogManager);
    } catch (_) {}
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ThemeManager stream dynamically updates root themeMode', (tester) async {
    await tester.pumpWidget(
      StreamBuilder<ThemeMode>(
        stream: ThemeManager.instance.themeModeStream,
        initialData: ThemeManager.instance.currentThemeMode,
        builder: (context, snapshot) {
          final mode = snapshot.data ?? ThemeMode.system;
          return MaterialApp(
            themeMode: mode,
            home: Scaffold(
              body: Text('CurrentMode: ${mode.name}'),
            ),
          );
        },
      ),
    );

    expect(find.text('CurrentMode: system'), findsOneWidget);

    await ThemeManager.instance.setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    expect(find.text('CurrentMode: dark'), findsOneWidget);

    await ThemeManager.instance.setThemeMode(ThemeMode.light);
    await tester.pumpAndSettle();

    expect(find.text('CurrentMode: light'), findsOneWidget);
  });

  testWidgets('LocalizationManager stream dynamically updates root locale', (tester) async {
    await tester.pumpWidget(
      StreamBuilder<Locale>(
        stream: LocalizationManager.instance.localeStream,
        initialData: const Locale('en'),
        builder: (context, snapshot) {
          final locale = snapshot.data ?? const Locale('en');
          return MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text('CurrentLocale: ${locale.languageCode}'),
            ),
          );
        },
      ),
    );

    expect(find.text('CurrentLocale: en'), findsOneWidget);

    await tester.runAsync(() async {
      await LocalizationManager.instance.setLocale(const Locale('vi'));
    });
    await tester.pump();

    expect(find.text('CurrentLocale: vi'), findsOneWidget);

    await tester.runAsync(() async {
      await LocalizationManager.instance.setLocale(const Locale('ja'));
    });
    await tester.pump();

    expect(find.text('CurrentLocale: ja'), findsOneWidget);
  });
}
