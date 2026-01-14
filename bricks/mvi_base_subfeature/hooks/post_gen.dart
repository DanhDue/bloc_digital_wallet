// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final moduleName = context.vars['module_name'] as String;
  final subfeatureName = context.vars['subfeature_name'] as String;

  final pascalCaseName = subfeatureName.pascalCase;
  final routeName = '${pascalCaseName}Route';

  // Path for subfeature: features/module/presentation/subfeature/subfeature_page.dart
  final pageImport =
      "import 'features/${moduleName.snakeCase}/presentation/${subfeatureName.snakeCase}/${subfeatureName.snakeCase}_page.dart';";

  final appRouterFile = File('lib/app_router.dart');

  if (!appRouterFile.existsSync()) {
    context.logger.err('Could not find lib/app_router.dart');
    return;
  }

  final lines = await appRouterFile.readAsLines();
  final newLines = <String>[];
  bool hasImport = false;
  bool hasRoute = false;

  for (final line in lines) {
    if (line.contains(pageImport)) {
      hasImport = true;
    }
    if (line.contains('$routeName.page')) {
      hasRoute = true;
    }
    newLines.add(line);
  }

  if (hasImport && hasRoute) {
    context.logger.info('$routeName already registered in app_router.dart');
    return;
  }

  final updatedLines = <String>[];
  bool importAdded = hasImport;
  bool routeAdded = hasRoute;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    // Add import after the last import or at top
    if (!importAdded &&
        line.startsWith('import ') &&
        (i + 1 == lines.length || !lines[i + 1].startsWith('import '))) {
      updatedLines.add(line);
      updatedLines.add(pageImport);
      importAdded = true;
      continue;
    }

    // Add route to routes list
    if (!routeAdded && line.contains('List<AutoRoute> get routes => [')) {
      updatedLines.add(line);
      updatedLines.add(
        "    AutoRoute(page: $routeName.page, path: '/${subfeatureName.paramCase}'),",
      );
      routeAdded = true;
      continue;
    }

    updatedLines.add(line);
  }

  if (!importAdded) {
    updatedLines.insert(0, pageImport);
  }

  await appRouterFile.writeAsString(updatedLines.join('\n'));
  context.logger.success('Added $routeName to app_router.dart');

  context.logger.info('Running build_runner...');
  final result = await Process.run(
      'dart',
      [
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
      ],
      runInShell: true);
  if (result.exitCode == 0) {
    context.logger.success('build_runner completed successfully.');
  } else {
    context.logger.err('build_runner failed: ${result.stderr}');
    context.logger.detail(result.stdout as String);
  }

  context.logger.info('Running dart format...');
  final fmtResult = await Process.run('dart', ['format', 'lib/', '-l', '99'], runInShell: true);
  if (fmtResult.exitCode == 0) {
    context.logger.success('dart format completed successfully.');
  } else {
    context.logger.err('dart format failed: ${fmtResult.stderr}');
    context.logger.detail(fmtResult.stdout as String);
  }
}
