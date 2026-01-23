// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../generated/translations.dart';
import 'app_initializer.dart';

class LocalizationInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Initialize slang translations
    LocaleSettings.useDeviceLocale();
  }
}
