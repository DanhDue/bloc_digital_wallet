// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:talker_flutter/talker_flutter.dart';

/// `GoodLog` - This class contains the basic structure of the log.
class GoodLog extends TalkerLog {
  GoodLog(String super.message);

  /// Log title
  @override
  String get title => 'good';

  /// Log key
  @override
  String get key => getKey;

  /// Log color
  @override
  AnsiPen get pen => getPen;

  static AnsiPen get getPen => AnsiPen()..xterm(121);

  static String get getKey => 'good';
}
