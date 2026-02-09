// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final moduleName = context.vars['module_name'] as String;
  final subfeatureName = context.vars['subfeature_name'] as String;

  final pascalCaseName = subfeatureName.pascalCase;
  final routeName = '${pascalCaseName}Route';
  final pageImport =
      "import 'features/${moduleName.snakeCase}/presentation/${subfeatureName.snakeCase}/${subfeatureName.snakeCase}_page.dart';";
  final camelCaseName = subfeatureName.camelCase;
  final paramCaseName = subfeatureName.paramCase;
  final routeConstant = 'AppRoutes.$camelCaseName';
  final routePath = "/$paramCaseName";
  final constantLine = "  static const String $camelCaseName = '$routePath';";

  final appRouterFile = File('lib/app_router.dart');

  if (!appRouterFile.existsSync()) {
    context.logger.err('Could not find lib/app_router.dart');
    return;
  }

  final lines = await appRouterFile.readAsLines();
  final updatedLines = <String>[];
  bool importAdded = false;
  bool routeAdded = false;
  bool constantAdded = false;

  // Check if already registered
  for (final line in lines) {
    if (line.contains(pageImport)) importAdded = true;
    if (line.contains('$routeName.page')) routeAdded = true;
    if (line.contains('static const String $camelCaseName =')) constantAdded = true;
  }

  if (importAdded && routeAdded && constantAdded) {
    context.logger.info('$pascalCaseName already registered in app_router.dart');
  } else {
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // 1. Add import
      if (!importAdded &&
          line.startsWith('import ') &&
          (i + 1 == lines.length || !lines[i + 1].startsWith('import '))) {
        updatedLines.add(line);
        updatedLines.add(pageImport);
        importAdded = true;
        continue;
      }

      // 2. Add route to routes list
      if (!routeAdded && line.contains('List<AutoRoute> get routes => [')) {
        updatedLines.add(line);
        updatedLines.add("    AutoRoute(page: $routeName.page, path: $routeConstant),");
        routeAdded = true;
        continue;
      }

      // 3. Add constant to AppRoutes class
      if (!constantAdded && line.contains('class AppRoutes {')) {
        updatedLines.add(line);
        updatedLines.add(constantLine);
        constantAdded = true;
        continue;
      }

      updatedLines.add(line);
    }

    if (!importAdded) updatedLines.insert(0, pageImport);

    await appRouterFile.writeAsString(updatedLines.join('\n'));
    context.logger.success('Registered $pascalCaseName in app_router.dart');
  }

  // Rebuild root app
  context.logger.info('Rebuilding root app...');
  final result = await Process.run('./scripts/rebuildAndFormat.sh', [], runInShell: true);
  if (result.exitCode == 0) {
    context.logger.success('Root app rebuild completed successfully.');
  } else {
    context.logger.err('Root app rebuild failed: ${result.stderr}');
    context.logger.detail(result.stdout as String);
  }
}
