// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final moduleName = context.vars['module_name'] as String;
  final subfeatureName = context.vars['subfeature_name'] as String;

  final snakeModule = moduleName.snakeCase;
  final snakeSubfeature = subfeatureName.snakeCase;
  final pascalSubfeature = subfeatureName.pascalCase;

  // Paths to be deleted
  final pathsToDelete = [
    // Presentation Directory
    'lib/features/$snakeModule/presentation/$snakeSubfeature',
    // Data Model
    'lib/features/$snakeModule/data/models/${snakeSubfeature}_model.dart',
    // Domain Entity
    'lib/features/$snakeModule/domain/entities/${snakeSubfeature}_entity.dart',
    // Domain UseCase
    'lib/features/$snakeModule/domain/usecases/get_${snakeSubfeature}_usecase.dart',
  ];

  // 1. Delete Files and Directories
  for (final path in pathsToDelete) {
    if (FileSystemEntity.isFileSync(path)) {
      try {
        File(path).deleteSync();
        context.logger.success('Deleted file: $path');
      } catch (e) {
        context.logger.err('Failed to delete file $path: $e');
      }
    } else if (FileSystemEntity.isDirectorySync(path)) {
      try {
        Directory(path).deleteSync(recursive: true);
        context.logger.success('Deleted directory: $path');
      } catch (e) {
        context.logger.err('Failed to delete directory $path: $e');
      }
    } else {
      context.logger.warn('Path not found: $path');
    }
  }

  // 2. Remove from AppRouter
  final appRouterFile = File('lib/app_router.dart');
  if (appRouterFile.existsSync()) {
    try {
      final lines = await appRouterFile.readAsLines();
      final updatedLines = <String>[];
      bool changed = false;

      // Import pattern to remove (matches the import structure used by mvi_subfeature)
      // import 'features/<module>/presentation/<subfeature>/<subfeature>_page.dart';
      final importPattern =
          "features/$snakeModule/presentation/$snakeSubfeature/${snakeSubfeature}_page.dart";

      // Route pattern to remove
      final routePattern = "${pascalSubfeature}Route.page";

      // Constant pattern to remove
      final constantPattern = "static const String ${subfeatureName.camelCase} =";

      for (final line in lines) {
        if (line.contains(importPattern)) {
          context.logger.info('Removed import for $snakeSubfeature');
          changed = true;
          continue;
        }
        if (line.contains(routePattern)) {
          context.logger.info('Removed route for $snakeSubfeature');
          changed = true;
          continue;
        }
        if (line.contains(constantPattern)) {
          context.logger.info('Removed AppRoutes constant for $snakeSubfeature');
          changed = true;
          continue;
        }
        updatedLines.add(line);
      }

      if (changed) {
        await appRouterFile.writeAsString(updatedLines.join('\n'));
        context.logger.success('Updated app_router.dart');
      } else {
        context.logger.info('No changes needed in app_router.dart');
      }
    } catch (e) {
      context.logger.err('Failed to update app_router.dart: $e');
    }
  }

  // 3. Run Build Runner
  context.logger.info('Running build_runner to clean up routes...');
  final buildResult = await Process.run(
      'fvm',
      [
        'dart',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
      ],
      runInShell: true);
  if (buildResult.exitCode == 0) {
    context.logger.success('build_runner completed successfully.');
  } else {
    context.logger.err('build_runner failed: ${buildResult.stderr}');
    context.logger.detail(buildResult.stdout as String);
  }

  // 4. Run Dart Format
  context.logger.info('Running dart format...');
  final fmtResult = await Process.run(
      'fvm',
      [
        'dart',
        'format',
        'lib/',
        '-l',
        '99',
      ],
      runInShell: true);
  if (fmtResult.exitCode == 0) {
    context.logger.success('dart format completed successfully.');
  } else {
    context.logger.err('dart format failed: ${fmtResult.stderr}');
    context.logger.detail(fmtResult.stdout as String);
  }
}
