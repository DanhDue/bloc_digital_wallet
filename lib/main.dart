// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:flutter/material.dart';

import 'app_router.dart';
import 'config/theme/app_themes.dart';
import 'config/environment_config.dart';
import 'di/injection.dart';
import 'generated/translations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize slang translations
  LocaleSettings.useDeviceLocale();

  // Print environment configuration
  EnvironmentConfig.printConfig();

  // Initialize dependency injection
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        title: EnvironmentConfig.appName,
        debugShowCheckedModeBanner: EnvironmentConfig.showDebugBanner,
        locale: LocaleSettings.currentLocale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        theme: ThemeData(
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
      ),
    );
  }
}
