// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:flutter/material.dart';

import 'app_router.dart';
import 'config/theme/app_theme.dart';
import 'config/environment_config.dart';
import 'di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: EnvironmentConfig.appName,
      debugShowCheckedModeBanner: EnvironmentConfig.showDebugBanner,
      theme: ThemeData(
        extensions: [AppThemes.light],
        colorScheme: ColorScheme.light(
          primary: AppThemes.light.primaryColor,
          secondary: AppThemes.light.secondaryColor,
          surface: AppThemes.light.surfaceColor,
          error: AppThemes.light.errorColor,
        ),
      ),
      darkTheme: ThemeData(
        extensions: [AppThemes.dark],
        colorScheme: ColorScheme.dark(
          primary: AppThemes.dark.primaryColor,
          secondary: AppThemes.dark.secondaryColor,
          surface: AppThemes.dark.surfaceColor,
          error: AppThemes.dark.errorColor,
        ),
      ),
    );
  }
}
