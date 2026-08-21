// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_router.dart';
import 'package:core/core.dart' as core;
import 'di/injection.dart';
import 'generated/translations.dart';
import 'config/app_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/multi_translation_provider.dart';
import 'core/localization/app_translation_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize ThemeManager
  await core.ThemeManager.instance.init();

  // Initialize App (Logging, Localization, Env, Bloc Observer, Auth Nav, etc.)
  await getIt<core.AppInitializer>().init();

  runApp(
    StreamBuilder<ThemeMode>(
      stream: core.ThemeManager.instance.themeModeStream,
      initialData: core.ThemeManager.instance.currentThemeMode,
      builder: (context, themeSnapshot) {
        final currentThemeMode = themeSnapshot.data ?? ThemeMode.system;

        return StreamBuilder<Locale>(
          stream: core.LocalizationManager.instance.localeStream,
          initialData: LocaleSettings.currentLocale.flutterLocale,
          builder: (context, snapshot) {
            final currentLocale = snapshot.data!;

            return MultiTranslationProvider(
              providers: appTranslationProviders,
              child: MaterialApp.router(
                routerConfig: getIt<AppRouter>().config(
                  navigatorObservers: () => [
                    FlutterSmartDialog.observer,
                    TalkerRouteObserver(getIt<Talker>()),
                  ],
                ),
                title: AppConfig.appName,
                debugShowCheckedModeBanner: core.EnvironmentConfig.showDebugBanner,
                locale: currentLocale,
                supportedLocales: AppLocaleUtils.supportedLocales,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                themeMode: currentThemeMode,
                theme: ThemeData(
                  scaffoldBackgroundColor: AppThemes.light.backgroundColor,
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  extensions: [AppThemes.light],
                  colorScheme: ColorScheme.light(
                    primary: AppThemes.light.primaryColor,
                    secondary: AppThemes.light.secondaryColor,
                    surface: AppThemes.light.surfaceColor,
                    error: AppThemes.light.errorColor,
                  ),
                ),
                darkTheme: ThemeData(
                  scaffoldBackgroundColor: AppThemes.dark.backgroundColor,
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  extensions: [AppThemes.dark],
                  colorScheme: ColorScheme.dark(
                    primary: AppThemes.dark.primaryColor,
                    secondary: AppThemes.dark.secondaryColor,
                    surface: AppThemes.dark.surfaceColor,
                    error: AppThemes.dark.errorColor,
                  ),
                ),
                builder: FlutterSmartDialog.init(
                  loadingBuilder: (String msg) => CustomLoadingWidget(msg: msg),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
