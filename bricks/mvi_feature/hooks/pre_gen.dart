// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  // Automatically set the year to the current year if not provided
  if (!context.vars.containsKey('year') || context.vars['year'] == null) {
    context.vars['year'] = DateTime.now().year;
  }
}
