// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// Replaces Flutter's red "DEBUG" ribbon with a flavor tag (e.g. `DEV`, `STG`)
/// in the top-right corner. Hidden for production builds (gated by the same
/// `SHOW_DEBUG_BANNER` dart-define that used to drive `debugShowCheckedModeBanner`).
class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!core.EnvironmentConfig.showDebugBanner) return child;

    return Banner(
      message: AppConfig.appSuffix.toUpperCase(),
      location: BannerLocation.topEnd,
      color: core.EnvironmentConfig.isStaging
          ? const Color(0xFFB26A00) // amber-ish for staging
          : const Color(0xFF2E7D32), // green for dev / anything else
      child: child,
    );
  }
}
