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

    // 4.5 Update lib/core/app_initializer/localization_initializer.dart - remove lines
    await _cleanLocalizationInitializer(snakeCaseName, camelCaseName);

    // 5. Update lib/app_router.dart - remove lines
    await _cleanAppRouter(snakeCaseName, pascalCaseName, camelCaseName);

    // 6. Update packages/core/lib/utils/feature_public_routes.dart - remove lines
    await _cleanFeaturePublicRoutes(snakeCaseName, pascalCaseName, camelCaseName);

    // 7. Update packages/network/lib/app_uri.dart - remove constant
    await _cleanAppUri(snakeCaseName, camelCaseName);

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

    progress.update('Running code generation on root app...');
    await _runCommand(
        'fvm',
        [
          'flutter',
          'pub',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs',
        ],
        context.logger);

    progress.update('Running formatting and analysis...');
    await _runCommand('melos', ['run', 'dartfmt'], context.logger);
    await _runCommand('melos', ['run', 'add-header-ignore-flags'], context.logger);
    await _runCommand('melos', ['run', 'add-license-header'], context.logger);
    await _runCommand('melos', ['run', 'analyze'], context.logger);

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

Future<void> _cleanLocalizationInitializer(String snakeName, String camelName) async {
  final file = File('lib/core/app_initializer/localization_initializer.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove import
  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/generated/translations.dart\'.*\\n', multiLine: true),
    '',
  );

  // Remove from _registerSyncLocaleCallback
  content = content.replaceAll(
    RegExp('^\\s*$camelName\\.LocaleSettings\\.setLocaleRaw\\(rawLocale\\);\\s*\\n', multiLine: true),
    '',
  );

  // Remove from _registerOverrideCallback
  final overridePattern = RegExp(
    '^\\s*await $camelName\\.LocaleSettings\\.overrideTranslationsFromMap\\([\\s\\S]*?\\);\\s*\\n',
    multiLine: true,
  );
  content = content.replaceAll(overridePattern, '');

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

Future<void> _cleanFeaturePublicRoutes(
  String snakeName,
  String pascalName,
  String camelName,
) async {
  final file = File('packages/core/lib/utils/feature_public_routes.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove public constants
  final publicRoutePattern = RegExp('''
  // $pascalName
  static const String $camelName = '/$camelName';
  static const PageRouteInfo ${camelName}Route = _${pascalName}Route\\(\\);
''', multiLine: true);
  content = content.replaceAll(publicRoutePattern, '');

  // Remove private class
  final privateClassPattern = RegExp('''
class _${pascalName}Route extends PageRouteInfo<void> \\{
  const _${pascalName}Route\\(\\) : super\\('${pascalName}Route'\\);
\\}
''', multiLine: true);
  content = content.replaceAll(privateClassPattern, '');

  await file.writeAsString(content);
}

Future<void> _cleanAppUri(String snakeName, String camelName) async {
  final file = File('packages/network/lib/app_uri.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Remove constant line: static const String myFeature = 'my_feature';
  final pattern = RegExp(
    '^\\s*static const String $camelName = \'$snakeName\';\\s*\\n',
    multiLine: true,
  );
  content = content.replaceAll(pattern, '');

  await file.writeAsString(content);
}
