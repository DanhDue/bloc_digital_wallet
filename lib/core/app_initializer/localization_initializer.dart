// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:core/core.dart' hide LocaleSettings;

class LocalizationInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Initialize slang translations
    LocaleSettings.useDeviceLocale();
  }
}
