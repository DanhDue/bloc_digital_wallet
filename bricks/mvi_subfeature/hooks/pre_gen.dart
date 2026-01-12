// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  // Auto-set year to current year
  context.vars['year'] = DateTime.now().year;

  final moduleName = context.vars['module_name'] as String;
  final moduleSnakeCase = moduleName.snakeCase;

  // Set entity name to module name if not provided
  if (context.vars['entity_name'] == null || (context.vars['entity_name'] as String).isEmpty) {
    context.vars['entity_name'] = moduleName;
  }

  // Check if module exists
  final moduleDir = Directory('lib/features/$moduleSnakeCase');
  if (!moduleDir.existsSync()) {
    context.logger.alert(
      'Warning: Module "$moduleName" does not exist at lib/features/$moduleSnakeCase',
    );
    context.logger.info(
      'The template will generate files, but you may need to create the module structure first.',
    );
  } else {
    context.logger.success('Found existing module: $moduleName');
  }
}
