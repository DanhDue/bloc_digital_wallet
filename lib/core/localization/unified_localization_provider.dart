// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import '../../generated/translations.dart' as app;
import 'package:authentication/authentication.dart' as auth;
import 'package:onboard/onboard.dart' as onboard;
import 'package:core/core.dart' as core_pkg;

/// A wrapper widget that encapsulates all TranslationProviders from different packages.
/// This solves the "TranslationProvider nesting hell" in main.dart.
class UnifiedLocalizationProvider extends StatelessWidget {
  final Widget child;
  const UnifiedLocalizationProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return app.TranslationProvider(
      child: auth.TranslationProvider(
        child: onboard.TranslationProvider(child: core_pkg.TranslationProvider(child: child)),
      ),
    );
  }
}
