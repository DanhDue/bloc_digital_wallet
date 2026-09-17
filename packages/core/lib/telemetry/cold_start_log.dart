// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:talker_flutter/talker_flutter.dart';

/// [ColdStartLog] - Dedicated Talker log entry for Cold Start Telemetry.
///
/// Provides a dedicated filter tag [title] of `COLD START` so developers
/// and QA can quickly isolate startup performance measurements in TalkerScreen.
class ColdStartLog extends TalkerLog {
  ColdStartLog(String super.message);

  /// Tag displayed in Talker and used for filter chips.
  @override
  String get title => 'COLD START';

  /// Key used by TalkerScreenTheme for color mapping.
  @override
  String get key => getKey;

  /// Ansi pen for terminal styling.
  @override
  AnsiPen get pen => getPen;

  /// Electric cyan ANSI pen for console logs.
  static AnsiPen get getPen => AnsiPen()..xterm(45);

  /// Key identifier for theme configuration.
  static String get getKey => 'cold_start';
}
