// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:talker_flutter/talker_flutter.dart';

/// Static wrapper for Talker logging
class Log {
  static late final Talker _talker;

  static void init(Talker talker) {
    _talker = talker;
  }

  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    _talker.debug(message, error, stackTrace);
  }

  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    _talker.info(message, error, stackTrace);
  }

  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    _talker.warning(message, error, stackTrace);
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _talker.error(message, error, stackTrace);
  }

  static void v(String message, {Object? error, StackTrace? stackTrace}) {
    _talker.verbose(message, error, stackTrace);
  }

  static void log(String message) {
    _talker.log(message);
  }
}
