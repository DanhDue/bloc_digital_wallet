// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/widgets.dart';
import '../../generated/translations.dart';
import 'package:core/core.dart' as core;
import 'package:authentication/authentication.dart' as auth;
import 'package:onboard/onboard.dart' as onboard;
import 'package:scanner/scanner.dart' as scanner;
import 'package:trends/trends.dart' as trends;
import 'package:wallet/wallet.dart' as wallet;
import 'package:settings/settings.dart' as settings;

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
  ({required child}) => scanner.TranslationProvider(child: child),
  ({required child}) => trends.TranslationProvider(child: child),
  ({required child}) => wallet.TranslationProvider(child: child),
  ({required child}) => settings.TranslationProvider(child: child),
];
