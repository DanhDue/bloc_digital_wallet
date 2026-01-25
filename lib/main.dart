// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:bloc_digital_wallet/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_router.dart';
import 'config/environment_config.dart';
import 'config/theme/app_themes.dart';
import 'core/app_initializer/app_initializer.dart';
import 'di/injection.dart';
import 'generated/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  configureDependencies();

  // Initialize App (Logging, Localization, Env, Bloc Observer, Auth Nav, etc.)
  await getIt<AppInitializer>().init();

  runApp(
    TranslationProvider(
      child: MaterialApp.router(
        routerConfig: getIt<AppRouter>().config(
          navigatorObservers: () => [
            FlutterSmartDialog.observer,
            TalkerRouteObserver(getIt<Talker>()),
          ],
        ),
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
        builder: FlutterSmartDialog.init(
          loadingBuilder: (String msg) => CustomLoadingWidget(msg: msg),
        ),
      ),
    ),
  );
}
