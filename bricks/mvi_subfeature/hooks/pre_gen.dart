// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:mason/mason.dart';

void run(HookContext context) {
  // Inject current year for copyright headers
  context.vars['year'] = DateTime.now().year;
}
