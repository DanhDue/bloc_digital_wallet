// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_platform/platform.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/shell/shell_bloc.dart';
import 'package:core/core.dart' hide test;
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';

import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/shell/shell_page.dart';

import 'package:ui_kit/ui_kit.dart';

import 'package:bloc_digital_wallet/core/localization/app_translation_providers.dart';
import 'package:bloc_digital_wallet/core/localization/multi_translation_provider.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    if (!getIt.isRegistered<AppRouter>()) {
      await configureDependencies();
    }
  });

  test(
    'configureDependencies initializes GetIt registrations and resolves all Blocs and services',
    () async {
      expect(getIt<AppRouter>(), isNotNull);
      expect(getIt<AppInitializer>(), isNotNull);
      expect(getIt<ThemeManager>(), isNotNull);
      expect(getIt<AppEventBus>(), isNotNull);
      expect(getIt<ShellBloc>(), isNotNull);
      expect(getIt<ToggleDarkModeUseCase>(), isNotNull);
      expect(getIt<SettingsBloc>(), isNotNull);
      expect(getIt<ScannerBloc>(), isNotNull);
    },
  );

  testWidgets('ShellPage pumps and mounts SettingsPage without runtime errors', (tester) async {
    await ThemeManager.instance.init();
    await getIt<AppInitializer>().init();

    await tester.pumpWidget(
      MultiTranslationProvider(
        providers: appTranslationProviders,
        child: MaterialApp(
          theme: ThemeData(extensions: [AppThemes.light]),
          home: const ShellPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ShellPage), findsOneWidget);
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
