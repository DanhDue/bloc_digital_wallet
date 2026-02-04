// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;
  final pascalCaseName = name.pascalCase;
  final camelCaseName = name.camelCase;

  final progress = context.logger.progress('Removing package $name...');

  try {
    // 1. Check if package exists
    final packageDir = Directory('packages/$snakeCaseName');
    if (!packageDir.existsSync()) {
      progress.fail('Package packages/$snakeCaseName does not exist!');
      return;
    }

    // 2. Confirm with user
    final confirm = context.logger.confirm(
      'Are you sure you want to remove packages/$snakeCaseName and all its registrations?',
      defaultValue: false,
    );

    if (!confirm) {
      progress.cancel();
      context.logger.info('Removal cancelled.');
      return;
    }

    // 3. Update lib/di/injection.dart - remove lines
    await _cleanInjection(snakeCaseName, camelCaseName);

    // 4. Update lib/core/localization/app_translation_providers.dart - remove lines
    await _cleanTranslationProviders(snakeCaseName, camelCaseName);

    // 5. Update lib/app_router.dart - remove lines
    await _cleanAppRouter(snakeCaseName, pascalCaseName, camelCaseName);

    // 6. Update pubspec.yaml workspace - remove package from workspace list
    await _cleanPubspecWorkspace(snakeCaseName);

    // Auto-remove from dependencies if present
    await _cleanPubspecDependencies(snakeCaseName);

    // 7. Delete the package directory
    await packageDir.delete(recursive: true);
    context.logger.info('Deleted packages/$snakeCaseName');

    // 8. Run Melos commands
    progress.update('Running melos bootstrap...');
    await _runCommand('melos', ['bootstrap'], context.logger);

    progress.update('Waiting for bootstrap to cool down...');
    await Future.delayed(const Duration(seconds: 10));

    progress.update('Running melos genAlls...');
    await _runCommand('melos', ['genAlls'], context.logger);

    progress.complete('Package $name removed successfully!');
  } catch (e) {
    progress.fail('Failed to remove package $name: $e');
  }
}

Future<void> _cleanInjection(String snakeName, String camelName) async {
  final file = File('lib/di/injection.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import line: import 'package:promo/promo.dart' as promo;
  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/$snakeName.dart\'.*\\n', multiLine: true),
    '',
  );

  // Remove configuration line: promo.configureModuleDependencies(getIt);
  content = content.replaceAll(
    RegExp('^\\s*$camelName\\.configureModuleDependencies\\(getIt\\);.*\\n', multiLine: true),
    '',
  );

  await file.writeAsString(content);
}

Future<void> _cleanTranslationProviders(String snakeName, String camelName) async {
  final file = File('lib/core/localization/app_translation_providers.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import line
  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/$snakeName.dart\'.*\\n', multiLine: true),
    '',
  );

  // Remove provider line: ({required child}) => promo.TranslationProvider(child: child),
  content = content.replaceAll(
    RegExp(
      '^\\s*\\(\\{required child\\}\\) => $camelName\\.TranslationProvider.*\\n',
      multiLine: true,
    ),
    '',
  );

  await file.writeAsString(content);
}

Future<void> _cleanAppRouter(String snakeName, String pascalName, String camelName) async {
  final file = File('lib/app_router.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import line
  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/$snakeName.dart\'.*\\n', multiLine: true),
    '',
  );

  // Remove export line
  content = content.replaceAll(
    RegExp('^export \'package:$snakeName/${snakeName}_router.dart\'.*\\n', multiLine: true),
    '',
  );

  // Remove router instance line
  content = content.replaceAll(
    RegExp(
      '^\\s*final _${camelName}Router = $camelName\\.${pascalName}Router\\(\\);.*\\n',
      multiLine: true,
    ),
    '',
  );

  // Remove routes spread line
  content = content.replaceAll(
    RegExp('^\\s*\\.\\.\\._${camelName}Router\\.routes,.*\\n', multiLine: true),
    '',
  );

  await file.writeAsString(content);
}

Future<void> _cleanPubspecWorkspace(String snakeName) async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove workspace entry line: - packages/promo
  content = content.replaceAll(RegExp('^\\s*- packages/$snakeName\\s*\\n', multiLine: true), '');

  await file.writeAsString(content);
}

Future<void> _cleanPubspecDependencies(String snakeName) async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove dependency block:
  //   promo:
  //     path: packages/promo

  // Match the key line "  promo:"
  // and the following path line "    path: packages/promo"
  // ensuring we handle indentation and newlines strictly.
  final dependencyPattern = RegExp(
    '^\\s*$snakeName:\\s*\\n\\s*path: packages/$snakeName\\s*\\n',
    multiLine: true,
  );
  content = content.replaceAll(dependencyPattern, '');

  // NOTE: If there was a blank line AFTER this block, it remains, preserving separation.
  // If there was no blank line and we wanted one, this simple removal might not add it,
  // but it won't eat the previous newline like \s* did.

  await file.writeAsString(content);
}

Future<void> _runCommand(String command, List<String> args, Logger logger) async {
  final result = await Process.run(command, args, runInShell: true);

  if (result.exitCode != 0) {
    logger.err('Command failed: $command ${args.join(' ')}');
    logger.err(result.stdout.toString());
    logger.err(result.stderr.toString());
    throw Exception('Command failed with exit code ${result.exitCode}');
  } else {
    logger.detail(result.stdout.toString());
  }
}
