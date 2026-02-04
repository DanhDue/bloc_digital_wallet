// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../app_router.dart';
import 'package:core/core.dart';

class AuthNavigationInitializer implements AppInitializer {
  final AuthStreamService _authService;
  final AppRouter _appRouter;

  AuthNavigationInitializer(this._authService, this._appRouter);

  @override
  Future<void> init() async {
    _authService.onLoggedOut.listen((_) {
      _appRouter.replaceAll([const LoginRoute()]);
    });
  }
}
