// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;
  final pascalCaseName = name.pascalCase;
  final camelCaseName = name.camelCase;

  final progress = context.logger.progress('Removing feature $name...');

  try {
    // 1. Check if feature exists in features/ or legacy packages/
    Directory featureDir = Directory('features/$snakeCaseName');
    if (!featureDir.existsSync()) {
      final legacyDir = Directory('packages/$snakeCaseName');
      if (legacyDir.existsSync()) {
        featureDir = legacyDir;
      } else {
        progress.fail('Feature $name does not exist in features/ or packages/!');
        return;
      }
    }

    // 2. Confirm with user if interactive terminal is available
    final bool confirm = stdout.hasTerminal
        ? context.logger.confirm(
            'Are you sure you want to remove ${featureDir.path} and all its registrations?',
            defaultValue: false,
          )
        : true;

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

    // 6. Update packages/platform/lib/deep_link_routes.dart - remove lines
    await _cleanFeaturePublicRoutes(snakeCaseName, pascalCaseName, camelCaseName);

    // 7. Update pubspec.yaml workspace - remove package from workspace list
    await _cleanPubspecWorkspace(snakeCaseName);

    // 8. Auto-remove from dependencies if present
    await _cleanPubspecDependencies(snakeCaseName);

    // 9. Delete the feature directory
    await featureDir.delete(recursive: true);
    context.logger.info('Deleted ${featureDir.path}');

    // 10. Run Melos commands
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

    progress.complete('Feature $name removed successfully!');
  } catch (e) {
    progress.fail('Failed to remove feature $name: $e');
  }
}

Future<void> _cleanInjection(String snakeName, String camelName) async {
  final file = File('lib/di/injection.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/$snakeName.dart\'.*\\n', multiLine: true),
    '',
  );

  content = content.replaceAll(
    RegExp('^\\s*(await\\s+)?($camelName|$snakeName)\\.configureModuleDependencies\\(getIt\\);.*\\n',
        multiLine: true),
    '',
  );

  await file.writeAsString(content);
}

Future<void> _cleanTranslationProviders(String snakeName, String camelName) async {
  final file = File('lib/core/localization/app_translation_providers.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/$snakeName.dart\'.*\\n', multiLine: true),
    '',
  );

  content = content.replaceAll(
    RegExp(
      '^\\s*\\(\\{required child\\}\\) => ($camelName|$snakeName)\\.TranslationProvider.*\\n',
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

  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/generated/translations.dart\'.*\\n', multiLine: true),
    '',
  );

  content = content.replaceAll(
    RegExp(
      '^\\s*($camelName|$snakeName)\\.LocaleSettings\\.setLocaleRaw\\(rawLocale\\);\\s*\\n',
      multiLine: true,
    ),
    '',
  );

  final overridePattern = RegExp(
    '^\\s*await ($camelName|$snakeName)\\.LocaleSettings\\.overrideTranslationsFromMap\\([\\s\\S]*?\\);\\s*\\n',
    multiLine: true,
  );
  content = content.replaceAll(overridePattern, '');

  await file.writeAsString(content);
}

Future<void> _cleanAppRouter(String snakeName, String pascalName, String camelName) async {
  final file = File('lib/app_router.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  content = content.replaceAll(
    RegExp('^import \'package:$snakeName/$snakeName.dart\'.*\\n', multiLine: true),
    '',
  );

  content = content.replaceAll(
    RegExp('^export \'package:$snakeName/${snakeName}_router.dart\'.*\\n', multiLine: true),
    '',
  );

  content = content.replaceAll(
    RegExp(
      '^\\s*final _${camelName}Router = ($camelName|$snakeName)\\.${pascalName}Router\\(\\);.*\\n',
      multiLine: true,
    ),
    '',
  );

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

  content = content.replaceAll(
      RegExp('^\\s*- (features|packages)/$snakeName\\s*\\n', multiLine: true), '');

  await file.writeAsString(content);
}

Future<void> _cleanPubspecDependencies(String snakeName) async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  final dependencyPattern = RegExp(
    '^\\s*$snakeName:\\s*\\n\\s*path: (features|packages)/$snakeName\\s*\\n',
    multiLine: true,
  );
  content = content.replaceAll(dependencyPattern, '');

  await file.writeAsString(content);
}

Future<void> _cleanFeaturePublicRoutes(
  String snakeName,
  String pascalName,
  String camelName,
) async {
  final file = File('packages/platform/lib/deep_link_routes.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  final publicRoutePattern = RegExp('''
  // $pascalName
  static const String $camelName = '/$camelName';
  static const PageRouteInfo ${camelName}Route = _${pascalName}Route\\(\\);
''', multiLine: true);
  content = content.replaceAll(publicRoutePattern, '');

  final privateClassPattern = RegExp('''
class _${pascalName}Route extends PageRouteInfo<void> \\{
  const _${pascalName}Route\\(\\) : super\\('${pascalName}Route'\\);
\\}
''', multiLine: true);
  content = content.replaceAll(privateClassPattern, '');

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
