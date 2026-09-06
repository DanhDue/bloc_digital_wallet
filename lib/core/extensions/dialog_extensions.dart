// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

extension AppDialogExtensions on BuildContext {
  void showCommingSoon() async {
    showWrapBottomSheet(
      const CommingSoonModalView(),
      routeSettings: const RouteSettings(name: AppRoutes.home),
    );
  }
}
