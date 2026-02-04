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

    // 7. Delete the package directory
    await packageDir.delete(recursive: true);
    context.logger.info('Deleted packages/$snakeCaseName');

    progress.complete('Package $name removed successfully!');

    context.logger.info('\nRemember to run:');
    context.logger.info('  melos bootstrap');
    context.logger.info('  melos genAlls');
  } catch (e) {
    progress.fail('Failed to remove package $name: $e');
  }
}

Future<void> _cleanInjection(String snakeName, String camelName) async {
  final file = File('lib/di/injection.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import line
  final importPattern = RegExp("import 'package:$snakeName/$snakeName.dart' as $camelName;\\n?");
  content = content.replaceAll(importPattern, '');

  // Remove configuration line
  final configPattern = RegExp("\\s*$camelName\\.configureModuleDependencies\\(getIt\\);\\n?");
  content = content.replaceAll(configPattern, '');

  await file.writeAsString(content);
}

Future<void> _cleanTranslationProviders(String snakeName, String camelName) async {
  final file = File('lib/core/localization/app_translation_providers.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import line
  final importPattern = RegExp("import 'package:$snakeName/$snakeName.dart' as $camelName;\\n?");
  content = content.replaceAll(importPattern, '');

  // Remove provider line
  final providerPattern = RegExp(
    "\\s*\\(\\{required child\\}\\) => $camelName\\.TranslationProvider\\(child: child\\),\\n?",
  );
  content = content.replaceAll(providerPattern, '');

  await file.writeAsString(content);
}

Future<void> _cleanAppRouter(String snakeName, String pascalName, String camelName) async {
  final file = File('lib/app_router.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import line
  final importPattern = RegExp("import 'package:$snakeName/$snakeName.dart' as $camelName;\\n?");
  content = content.replaceAll(importPattern, '');

  // Remove export line
  final exportPattern = RegExp("export 'package:$snakeName/${snakeName}_router.dart';\\n?");
  content = content.replaceAll(exportPattern, '');

  // Remove router instance line
  final instancePattern = RegExp(
    "\\s*final _${camelName}Router = $camelName\\.${pascalName}Router\\(\\);\\n?",
  );
  content = content.replaceAll(instancePattern, '');

  // Remove routes spread line
  final routesPattern = RegExp("\\s*\\.\\.\\._${camelName}Router\\.routes,\\n?");
  content = content.replaceAll(routesPattern, '');

  await file.writeAsString(content);
}

Future<void> _cleanPubspecWorkspace(String snakeName) async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove workspace entry line
  final workspacePattern = RegExp("\\s*- packages/$snakeName\\n?");
  content = content.replaceAll(workspacePattern, '\n');

  await file.writeAsString(content);
}
