// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/widgets.dart';
import '../../generated/translations.dart';
import 'package:core/core.dart' as core;
import 'package:authentication/authentication.dart' as auth;
import 'package:onboard/onboard.dart' as onboard;

/// List of all TranslationProviders for the application.
/// Add new feature providers here.
final List<Widget Function({required Widget child})> appTranslationProviders = [
  // Core
  ({required child}) => core.TranslationProvider(child: child),

  // App Main
  ({required child}) => TranslationProvider(child: child),

  // Features
  ({required child}) => auth.TranslationProvider(child: child),
  ({required child}) => onboard.TranslationProvider(child: child),
];
