// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final packageName = context.vars['package_name'] as String;
  final subfeatureName = context.vars['subfeature_name'] as String;

  final snakePackage = packageName.snakeCase;
  final snakeSubfeature = subfeatureName.snakeCase;
  final pascalSubfeature = subfeatureName.pascalCase;
  final camelSubfeature = subfeatureName.camelCase;
  final pascalPackage = packageName.pascalCase;

  final progress = context.logger.progress(
    'Removing subfeature $subfeatureName from $packageName...',
  );

  try {
    // 1. Delete Files and Directories
    final filesToDelete = [
      'packages/$snakePackage/lib/presentation/$snakeSubfeature',
      'packages/$snakePackage/lib/data/datasources/remote/${snakeSubfeature}_client.dart',
      'packages/$snakePackage/lib/data/datasources/remote/${snakeSubfeature}_remote_datasource.dart',
      'packages/$snakePackage/lib/data/models/${snakeSubfeature}_model.dart',
      'packages/$snakePackage/lib/data/repositories/${snakeSubfeature}_repository_impl.dart',
      'packages/$snakePackage/lib/domain/entities/${snakeSubfeature}_entity.dart',
      'packages/$snakePackage/lib/domain/repositories/${snakeSubfeature}_repository.dart',
      'packages/$snakePackage/lib/domain/usecases/get_${snakeSubfeature}_usecase.dart',
    ];

    for (final path in filesToDelete) {
      if (FileSystemEntity.isFileSync(path)) {
        File(path).deleteSync();
        context.logger.info('Deleted file: $path');
      } else if (FileSystemEntity.isDirectorySync(path)) {
        Directory(path).deleteSync(recursive: true);
        context.logger.info('Deleted directory: $path');
      }
    }

    // 2. Remove Exports from {package}.dart
    await _removeExports(snakePackage, snakeSubfeature);

    // 3. Remove Route from {package}_router.dart
    await _removeRoute(
      snakePackage,
      snakeSubfeature,
      pascalSubfeature,
      pascalPackage,
      camelSubfeature,
    );

    progress.complete('Removed subfeature $subfeatureName from $packageName!');

    context.logger.info('Running melos genAlls to update router and DI...');
    final result = await Process.run('melos', ['genAlls'], runInShell: true);
    if (result.exitCode == 0) {
      context.logger.success('melos genAlls completed successfully.');
    } else {
      context.logger.err('melos genAlls failed: ${result.stderr}');
    }
  } catch (e) {
    progress.fail('Failed to remove subfeature: $e');
  }
}

Future<void> _removeExports(String snakePackage, String snakeSubfeature) async {
  final file = File('packages/$snakePackage/lib/$snakePackage.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  final exportPattern = "/$snakeSubfeature/"; // Matches any export containing the subfeature path

  for (final line in lines) {
    if (!line.contains(exportPattern)) {
      updatedLines.add(line);
    }
  }

  await file.writeAsString(updatedLines.join('\n'));
}

Future<void> _removeRoute(
  String snakePackage,
  String snakeSubfeature,
  String pascalSubfeature,
  String pascalPackage,
  String camelSubfeature,
) async {
  final file = File('packages/$snakePackage/lib/${snakePackage}_router.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  // Patterns to remove
  final importPattern = "presentation/$snakeSubfeature/${snakeSubfeature}_page.dart";
  final routePattern = "path: ${pascalPackage}Routes.$camelSubfeature";
  // Note: routePattern might be partial, checking for usage of the constant is safer
  // Or checking for the AutoRoute definition that uses the page
  final pagePattern = "${pascalSubfeature}Route.page";

  // Constant pattern in Routes class
  final constantPattern = "static const String $camelSubfeature =";

  for (final line in lines) {
    if (line.contains(importPattern)) continue;
    if (line.contains(pagePattern)) continue;
    if (line.contains(constantPattern)) continue;
    updatedLines.add(line);
  }

  // Clean up empty Routes class if needed? Likely not worth the complexity yet.

  await file.writeAsString(updatedLines.join('\n'));
}
