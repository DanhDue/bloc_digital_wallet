// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import '../../generated/translations.dart' as app;
import 'package:core/core.dart' as core_pkg;
import 'package:scanner/scanner.dart' as scanner;
import 'package:settings/settings.dart' as settings;

/// A wrapper widget that encapsulates all TranslationProviders from different packages.
/// This solves the "TranslationProvider nesting hell" in main.dart.
class UnifiedLocalizationProvider extends StatelessWidget {
  final Widget child;
  const UnifiedLocalizationProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return app.TranslationProvider(
      child: core_pkg.TranslationProvider(
        child: scanner.TranslationProvider(child: settings.TranslationProvider(child: child)),
      ),
    );
  }
}
