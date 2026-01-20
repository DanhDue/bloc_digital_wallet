// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final featureName = 'sample';
  final snakeCaseName = featureName.snakeCase;
  final pascalCaseName = featureName.pascalCase;

  // 1. Delete Feature Directory
  final featureDir = Directory('lib/features/$snakeCaseName');
  if (featureDir.existsSync()) {
    try {
      featureDir.deleteSync(recursive: true);
      context.logger.success('Deleted directory: lib/features/$snakeCaseName');
    } catch (e) {
      context.logger.err('Failed to delete directory: $e');
    }
  } else {
    context.logger.warn('Directory not found: lib/features/$snakeCaseName');
  }

  // 2. Remove from AppRouter
  final appRouterFile = File('lib/app_router.dart');
  if (appRouterFile.existsSync()) {
    try {
      final lines = await appRouterFile.readAsLines();
      final updatedLines = <String>[];
      bool changed = false;

      // Import pattern to remove
      final importPattern =
          "features/$snakeCaseName/presentation/$snakeCaseName/${snakeCaseName}_page.dart";
      // Route pattern to remove
      final routePattern = "${pascalCaseName}Route.page";

      // Constant pattern to remove
      final constantPattern = "static const String ${featureName.camelCase} =";

      for (final line in lines) {
        if (line.contains(importPattern)) {
          context.logger.info('Removed import for $snakeCaseName');
          changed = true;
          continue;
        }
        if (line.contains(routePattern)) {
          context.logger.info('Removed route for $snakeCaseName');
          changed = true;
          continue;
        }
        if (line.contains(constantPattern)) {
          context.logger.info('Removed AppRoutes constant for $snakeCaseName');
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
      'dart',
      [
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
  final fmtResult = await Process.run('dart', ['format', 'lib/', '-l', '99'], runInShell: true);
  if (fmtResult.exitCode == 0) {
    context.logger.success('dart format completed successfully.');
  } else {
    context.logger.err('dart format failed: ${fmtResult.stderr}');
    context.logger.detail(fmtResult.stdout as String);
  }
}
