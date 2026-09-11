// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_links/app_links.dart';
import 'package:app_platform/platform.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:d3_nexus_shield/app_router.dart';
import 'package:d3_nexus_shield/core/app_initializer/bloc_observer_initializer.dart';
import 'package:d3_nexus_shield/core/app_initializer/environment_initializer.dart';
import 'package:d3_nexus_shield/core/app_initializer/localization_initializer.dart';
import 'package:d3_nexus_shield/core/app_initializer/logging_initializer.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_auth_guard.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_coordinator.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_navigator.dart';
import 'package:d3_nexus_shield/di/injection.dart';
import 'package:d3_nexus_shield/shell/shell_bloc.dart';

@module
abstract class AppModule {
  @singleton
  LoggingInitializer get loggingInitializer => LoggingInitializer();

  @singleton
  LocalizationInitializer get localizationInitializer => LocalizationInitializer();

  @singleton
  EnvironmentInitializer get environmentInitializer => EnvironmentInitializer();

  @singleton
  BlocObserverInitializer get blocObserverInitializer => BlocObserverInitializer();

  @singleton
  ImageCacheInitializer get imageCacheInitializer => const ImageCacheInitializer();

  @singleton
  MemoryPressureObserver provideMemoryPressureObserver() =>
      MemoryPressureObserver(eventBus: getIt<AppEventBus>());

  @singleton
  AppRouter get appRouter => AppRouter();

  @singleton
  AppLinks get appLinks => AppLinks();

  @singleton
  DeepLinkParser get deepLinkParser => const DeepLinkParser();

  @singleton
  AppInitializer provideAppInitializer(
    LoggingInitializer loggingInitializer,
    LocalizationInitializer localizationInitializer,
    EnvironmentInitializer environmentInitializer,
    BlocObserverInitializer blocObserverInitializer,
    ImageCacheInitializer imageCacheInitializer,
    MemoryPressureObserver memoryPressureObserver,
  ) {
    return AppInitializerImpl([
      loggingInitializer,
      localizationInitializer,
      environmentInitializer,
      blocObserverInitializer,
      imageCacheInitializer,
      memoryPressureObserver,
    ]);
  }

  @lazySingleton
  DeepLinkNavigator provideDeepLinkNavigator(AppRouter appRouter) {
    return DeepLinkNavigator(shellBlocProvider: () => getIt<ShellBloc>(), appRouter: appRouter);
  }

  @lazySingleton
  DeepLinkCoordinator provideDeepLinkCoordinator(
    AppLinks appLinks,
    DeepLinkParser parser,
    DeepLinkNavigator navigator,
  ) {
    final authGuard = DeepLinkAuthGuard(
      eventBus: getIt<AppEventBus>(),
      isAuthenticated: () => true,
      onRequireLogin: () {
        navigator.navigate(const DeepLinkPayload(path: DeepLinkRoutes.login));
      },
    );
    return DeepLinkCoordinator(
      appLinks: appLinks,
      parser: parser,
      onNavigate: (payload) => navigator.navigate(payload),
      authGuard: authGuard,
    );
  }
}
