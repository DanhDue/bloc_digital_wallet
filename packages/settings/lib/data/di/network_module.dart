// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:network/extensions/string_ext.dart';
import 'package:settings/data/datasources/remote/settings_uri.dart';
import 'package:settings/data/datasources/remote/settings_client.dart';
import 'package:settings/data/datasources/remote/translation_client.dart';

@module
abstract class SettingsNetworkModule {
  @lazySingleton
  SettingsClient settingsClient(Dio dio) =>
      SettingsClient(dio, baseUrl: SettingsUri.settings.buildAppUri());

  @lazySingleton
  TranslationClient translationClient(Dio dio) =>
      TranslationClient(dio, baseUrl: SettingsUri.translations.buildAppUri());
}
