// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final packageName = context.vars['package_name'] as String;
  final subfeatureName = context.vars['subfeature_name'] as String;

  final snakePackage = packageName.snakeCase;
  final snakeSubfeature = subfeatureName.snakeCase;
  final pascalPackage = packageName.pascalCase;
  final pascalSubfeature = subfeatureName.pascalCase;
  final camelSubfeature = subfeatureName.camelCase;

  final progress = context.logger.progress(
    'Removing subfeature $subfeatureName from $packageName...',
  );

  try {
    // 1. Delete subfeature-specific files (NOT separate repository/datasource/client)
    final filesToDelete = [
      'packages/$snakePackage/lib/presentation/$snakeSubfeature',
      'packages/$snakePackage/lib/data/models/${snakeSubfeature}_model.dart',
      'packages/$snakePackage/lib/domain/entities/${snakeSubfeature}_entity.dart',
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

    // 2. Remove method from parent's repository interface
    await _removeFromRepositoryInterface(
      snakePackage,
      snakeSubfeature,
      pascalPackage,
      pascalSubfeature,
    );

    // 3. Remove method from parent's repository implementation
    await _removeFromRepositoryImpl(
      snakePackage,
      snakeSubfeature,
      pascalPackage,
      pascalSubfeature,
    );

    // 4. Remove method from parent's remote datasource
    await _removeFromRemoteDataSource(
      snakePackage,
      snakeSubfeature,
      pascalPackage,
      pascalSubfeature,
    );

    // 5. Remove endpoint from parent's client
    await _removeFromClient(snakePackage, snakeSubfeature, pascalPackage, pascalSubfeature);

    // 6. Remove Exports from {package}.dart
    await _removeExports(snakePackage, snakeSubfeature);

    // 7. Remove Route from {package}_router.dart
    await _removeRoute(
      snakePackage,
      snakeSubfeature,
      pascalSubfeature,
      pascalPackage,
      camelSubfeature,
    );

    progress.complete('Removed subfeature $subfeatureName from $packageName!');

    // Only rebuild the affected package using genFeature
    context.logger.info('Rebuilding $snakePackage package...');
    final packageResult = await Process.run(
        'melos',
        [
          'genFeature',
          snakePackage,
        ],
        runInShell: true);
    if (packageResult.exitCode == 0) {
      context.logger.success('Rebuild completed successfully.');
    } else {
      context.logger.err('Package rebuild failed: ${packageResult.stderr}');
    }
  } catch (e) {
    progress.fail('Failed to remove subfeature: $e');
  }
}

/// Remove method from parent's repository interface
Future<void> _removeFromRepositoryInterface(
  String snakePackage,
  String snakeSubfeature,
  String pascalPackage,
  String pascalSubfeature,
) async {
  final file = File(
    'packages/$snakePackage/lib/domain/repositories/${snakePackage}_repository.dart',
  );
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  final importPattern =
      "import 'package:$snakePackage/domain/entities/${snakeSubfeature}_entity.dart';";
  final methodPattern = 'get$pascalSubfeature()';

  for (final line in lines) {
    if (line.contains(importPattern)) continue;
    if (line.contains(methodPattern)) continue;
    updatedLines.add(line);
  }

  await file.writeAsString(updatedLines.join('\n'));
}

/// Remove method from parent's repository implementation
Future<void> _removeFromRepositoryImpl(
  String snakePackage,
  String snakeSubfeature,
  String pascalPackage,
  String pascalSubfeature,
) async {
  final file = File(
    'packages/$snakePackage/lib/data/repositories/${snakePackage}_repository_impl.dart',
  );
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  final importPattern =
      "import 'package:$snakePackage/domain/entities/${snakeSubfeature}_entity.dart';";
  final methodPattern = 'get$pascalSubfeature()';

  var skipUntilBrace = false;
  var braceCount = 0;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    // Skip import line
    if (line.contains(importPattern)) continue;

    // Skip method declaration and body
    if (line.contains('@override') &&
        i + 1 < lines.length &&
        lines[i + 1].contains(methodPattern)) {
      skipUntilBrace = true;
      braceCount = 0;
      continue;
    }

    if (line.contains(methodPattern) && !skipUntilBrace) {
      skipUntilBrace = true;
      braceCount = 0;
    }

    if (skipUntilBrace) {
      braceCount += '{'.allMatches(line).length;
      braceCount -= '}'.allMatches(line).length;
      if (braceCount <= 0 && line.contains('}')) {
        skipUntilBrace = false;
        continue;
      }
      continue;
    }

    updatedLines.add(line);
  }

  await file.writeAsString(updatedLines.join('\n'));
}

/// Remove method from parent's remote datasource
Future<void> _removeFromRemoteDataSource(
  String snakePackage,
  String snakeSubfeature,
  String pascalPackage,
  String pascalSubfeature,
) async {
  final file = File(
    'packages/$snakePackage/lib/data/datasources/remote/${snakePackage}_remote_datasource.dart',
  );
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  final modelImportPattern =
      "import 'package:$snakePackage/data/models/${snakeSubfeature}_model.dart';";
  final entityImportPattern =
      "import 'package:$snakePackage/domain/entities/${snakeSubfeature}_entity.dart';";
  final methodPattern = 'get$pascalSubfeature()';

  var skipUntilBrace = false;
  var braceCount = 0;

  for (final line in lines) {
    // Skip import lines
    if (line.contains(modelImportPattern)) continue;
    if (line.contains(entityImportPattern)) continue;

    // Skip method declaration and body
    if (line.contains(methodPattern) && !skipUntilBrace) {
      skipUntilBrace = true;
      braceCount = 0;
    }

    if (skipUntilBrace) {
      braceCount += '{'.allMatches(line).length;
      braceCount -= '}'.allMatches(line).length;
      if (braceCount <= 0 && line.contains('}')) {
        skipUntilBrace = false;
        continue;
      }
      continue;
    }

    updatedLines.add(line);
  }

  await file.writeAsString(updatedLines.join('\n'));
}

/// Remove endpoint from parent's client
Future<void> _removeFromClient(
  String snakePackage,
  String snakeSubfeature,
  String pascalPackage,
  String pascalSubfeature,
) async {
  final file = File(
    'packages/$snakePackage/lib/data/datasources/remote/${snakePackage}_client.dart',
  );
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  final modelImportPattern =
      "import 'package:$snakePackage/data/models/${snakeSubfeature}_model.dart';";
  final methodPattern = 'get$pascalSubfeature()';
  final getAnnotationPattern = "@GET('/$snakeSubfeature')";

  var skipNextLine = false;

  for (final line in lines) {
    // Skip import line
    if (line.contains(modelImportPattern)) continue;

    // Skip @GET annotation - will skip the method on next iteration
    if (line.contains(getAnnotationPattern)) {
      skipNextLine = true;
      continue;
    }

    if (skipNextLine) {
      skipNextLine = false;
      continue;
    }

    // Skip method if not already skipped
    if (line.contains(methodPattern)) continue;

    updatedLines.add(line);
  }

  await file.writeAsString(updatedLines.join('\n'));
}

Future<void> _removeExports(String snakePackage, String snakeSubfeature) async {
  final file = File('packages/$snakePackage/lib/$snakePackage.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  final lines = content.split('\n');
  final updatedLines = <String>[];

  // Patterns to remove - both presentation and domain exports
  final presentationPattern = "/$snakeSubfeature/";
  final entityPattern = "/${snakeSubfeature}_entity.dart";
  final usecasePattern = "/get_${snakeSubfeature}_usecase.dart";

  for (final line in lines) {
    if (line.contains(presentationPattern)) continue;
    if (line.contains(entityPattern)) continue;
    if (line.contains(usecasePattern)) continue;
    updatedLines.add(line);
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
  final pagePattern = "${pascalSubfeature}Route.page";
  final constantPattern = "static const String $camelSubfeature =";

  for (final line in lines) {
    if (line.contains(importPattern)) continue;
    if (line.contains(pagePattern)) continue;
    if (line.contains(constantPattern)) continue;
    updatedLines.add(line);
  }

  await file.writeAsString(updatedLines.join('\n'));
}
