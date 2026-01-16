// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:bloc_digital_wallet/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_router.dart';
import 'config/theme/app_themes.dart';
import 'config/environment_config.dart';
import 'di/injection.dart';
import 'generated/translations.dart';
import 'dart:async';
import 'core/services/auth_stream_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize slang translations
  LocaleSettings.useDeviceLocale();

  // Print environment configuration
  EnvironmentConfig.printConfig();

  // Initialize dependency injection
  configureDependencies();

  // Initialize Bloc Observer
  Bloc.observer = TalkerBlocObserver(
    talker: getIt<Talker>(),
    settings: const TalkerBlocLoggerSettings(printStateFullData: false, printEventFullData: false),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final _appRouter = AppRouter();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = getIt<AuthStreamService>().onLoggedOut.listen((_) {
      MyApp._appRouter.replaceAll([const LoginRoute()]);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp.router(
        routerConfig: MyApp._appRouter.config(
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
    );
  }
}
