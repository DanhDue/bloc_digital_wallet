// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:d3_nexus_shield/generated/translations.dart' as root;
import 'package:flutter/cupertino.dart';

void main() {
  final code = 'ko_KR';
  final locale = root.AppLocaleUtils.parse(code);
  debugPrint('Parsed $code as ${locale.languageCode}');
}
