// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class SettingsLocalModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
