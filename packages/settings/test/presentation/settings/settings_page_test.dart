// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/presentation/settings/models/settings_ui_model.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_page.dart';
import 'package:settings/presentation/settings/widgets/settings_item_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:settings/generated/translations.dart' as settings_lang;

import 'package:mocktail/mocktail.dart' as mocktail;
class MockLogManager extends mocktail.Mock implements ILogManager {}
class MockLogger extends mocktail.Mock implements ILogger {}
class MockSettingsBloc extends mocktail.Mock implements SettingsBloc {}

void main() {
  late MockSettingsBloc mockSettingsBloc;

  setUpAll(() {
    if (!GetIt.I.isRegistered<Talker>()) {
      GetIt.I.registerSingleton<Talker>(Talker());
    }
    mocktail.registerFallbackValue(const SettingsAction.started());
    
    // 1. Mock shared preferences
    SharedPreferences.setMockInitialValues({});

    // 2. Initialize the logger ONCE
    final mockLogManager = MockLogManager();
    mocktail.when(() => mockLogManager.getLogger(mocktail.any())).thenReturn(MockLogger());
    try {
      D3NexusLogger.initialize(mockLogManager);
    } catch (_) {}
    
    // Initialize LocalizationManager for testing ONCE to avoid Provider setState after dispose
    settings_lang.LocaleSettings.setLocale(settings_lang.SettingsAppLocale.en);
    LocalizationManager.instance.setLocale(const Locale('en', 'US'));
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    if (!GetIt.I.isRegistered<SettingsBloc>()) {
      GetIt.I.registerSingleton<SettingsBloc>(mockSettingsBloc);
    } else {
      // In case tests run in the same process
      GetIt.I.unregister<SettingsBloc>();
      GetIt.I.registerSingleton<SettingsBloc>(mockSettingsBloc);
    }
    mocktail.when(() => mockSettingsBloc.state).thenReturn(
      const SettingsState(
        status: SettingsStatus.success,
        uiModel: SettingsUiModel(
          id: 'mock_settings_ui',
          availableLanguages: [
            AvailableLanguage(languageCode: 'en', languageName: 'English', isDefault: true, isActive: true),
            AvailableLanguage(languageCode: 'vi', languageName: 'Tiếng Việt', isDefault: false, isActive: true),
          ],
        ),
      ),
    );
    mocktail.when(() => mockSettingsBloc.stream).thenAnswer((_) => const Stream.empty());
    mocktail.when(() => mockSettingsBloc.events).thenAnswer((_) => const Stream.empty());
    mocktail.when(() => mockSettingsBloc.close()).thenAnswer((_) async => {});
  });

  tearDown(() {
    mockSettingsBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: settings_lang.TranslationProvider(
        child: Scaffold(
          body: BlocProvider<SettingsBloc>.value(
            value: mockSettingsBloc,
            child: const SettingsPage(),
          ),
        ),
      ),
    );
  }

  testWidgets('Selecting a new language dispatches changeLanguage action', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final languageIcon = find.byIcon(Icons.language);
    expect(languageIcon, findsOneWidget);
    await tester.tap(languageIcon);
    await tester.pumpAndSettle(); 

    final viLanguage = find.text('Tiếng Việt');
    expect(viLanguage, findsOneWidget);
    await tester.tap(viLanguage);
    await tester.pumpAndSettle();

    mocktail.verify(() => mockSettingsBloc.onAction(const SettingsAction.changeLanguage(languageCode: 'vi'))).called(1);
  });

  testWidgets('Tapping Profile dispatches navigateToProfile action', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final profileIcon = find.byIcon(Icons.person_outline);
    expect(profileIcon, findsOneWidget);
    await tester.tap(profileIcon);
    await tester.pumpAndSettle();

    mocktail.verify(() => mockSettingsBloc.onAction(const SettingsAction.navigateToProfile())).called(1);
  });

  testWidgets('Tapping Change Password dispatches navigateToSecurity action', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final lockIcon = find.byIcon(Icons.lock_outline);
    expect(lockIcon, findsOneWidget);
    await tester.tap(lockIcon);
    await tester.pumpAndSettle();

    mocktail.verify(() => mockSettingsBloc.onAction(const SettingsAction.navigateToSecurity())).called(1);
  });

  testWidgets('Toggling Dark Mode dispatches toggleDarkMode action', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final darkModeSwitch = find.descendant(
      of: find.ancestor(
        of: find.byIcon(Icons.dark_mode_outlined),
        matching: find.byType(SettingsItemWidget),
      ),
      matching: find.byType(CupertinoSwitch),
    );
    
    await tester.tap(darkModeSwitch);
    await tester.pumpAndSettle();

    mocktail.verify(() => mockSettingsBloc.onAction(const SettingsAction.toggleDarkMode(isEnabled: true))).called(1);
  });

  testWidgets('Toggling Developer Mode dispatches toggleDeveloperMode action', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final devModeSwitch = find.descendant(
      of: find.ancestor(
        of: find.byIcon(Icons.bug_report_outlined),
        matching: find.byType(SettingsItemWidget),
      ),
      matching: find.byType(CupertinoSwitch),
    );
    
    await tester.tap(devModeSwitch);
    await tester.pumpAndSettle();

    mocktail.verify(() => mockSettingsBloc.onAction(const SettingsAction.toggleDeveloperMode(isEnabled: true))).called(1);
  });
}
