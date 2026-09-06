// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;
  final pascalCaseName = name.pascalCase;
  final camelCaseName = name.camelCase;

  final progress = context.logger.progress('Integrating feature $name...');

  try {
    // 1. Update root pubspec.yaml (workspace & dependencies)
    await _updateRootPubspec(snakeCaseName);

    // 2. Update lib/di/injection.dart
    await _updateInjection(snakeCaseName);

    // 3. Update lib/core/localization/app_translation_providers.dart
    await _updateTranslationProviders(snakeCaseName);

    // 4. Update lib/core/app_initializer/localization_initializer.dart
    await _updateLocalizationInitializer(snakeCaseName);

    // 5. Update lib/app_router.dart
    await _updateAppRouter(snakeCaseName, pascalCaseName, camelCaseName);

    // 6. Update DeepLinkRoutes
    progress.update('Updating DeepLinkRoutes...');
    await _updateFeaturePublicRoutes(snakeCaseName, pascalCaseName, camelCaseName);

    // 7. Run Melos commands
    progress.update('Running melos bootstrap...');
    await _runCommand('melos', ['bootstrap'], context.logger);

    progress.update('Running scoped code generation...');
    await _runCommand('./scripts/integrateFeatureToApp.sh', [snakeCaseName], context.logger);

    progress.complete('Feature $name integrated successfully!');
  } catch (e) {
    progress.fail('Failed to integrate feature $name: $e');
  }
}

Future<void> _updateRootPubspec(String snakeName) async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add to workspace
  if (!content.contains("features/$snakeName")) {
    final workspaceMarker = "workspace:";
    if (content.contains(workspaceMarker)) {
      final workspaceRegex = RegExp(r'workspace:\s*\n(\s+- .*\n)+');
      final match = workspaceRegex.firstMatch(content);

      if (match != null) {
        final currentWorkspaceBlock = match.group(0)!;
        final newWorkspaceBlock = currentWorkspaceBlock.endsWith('\n')
            ? "${currentWorkspaceBlock}  - features/$snakeName\n"
            : "$currentWorkspaceBlock\n  - features/$snakeName\n";

        content = content.replaceFirst(currentWorkspaceBlock, newWorkspaceBlock);
      }
    }
  }

  // Add to dependencies
  if (!content.contains("$snakeName:")) {
    final dependenciesMarker = "dependencies:";
    if (content.contains(dependenciesMarker)) {
      final settingsMarker = "path: features/settings";
      if (content.contains(settingsMarker)) {
        content = content.replaceFirst(
          settingsMarker,
          "$settingsMarker\n  $snakeName:\n    path: features/$snakeName",
        );
      } else {
        content = content.replaceFirst(
          dependenciesMarker,
          "$dependenciesMarker\n  $snakeName:\n    path: features/$snakeName",
        );
      }
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateInjection(String snakeName) async {
  final file = File('lib/di/injection.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add import
  if (!content.contains("package:$snakeName/$snakeName.dart")) {
    final importMarker = "import 'package:settings/settings.dart' as settings;";
    if (content.contains(importMarker)) {
      content = content.replaceFirst(
        importMarker,
        "$importMarker\nimport 'package:$snakeName/$snakeName.dart' as $snakeName;",
      );
    } else {
      final lastImport = RegExp(r"import 'package:.*';");
      content = content.replaceFirstMapped(lastImport, (match) {
        return "${match.group(0)}\nimport 'package:$snakeName/$snakeName.dart' as $snakeName;";
      });
    }
  }

  // Add dependency configuration
  if (!content.contains("$snakeName.configureModuleDependencies(getIt);")) {
    final configMarker = RegExp(
        r'(await\s+settings\.configureModuleDependencies\(getIt\);|settings\.configureModuleDependencies\(getIt\);)');
    if (configMarker.hasMatch(content)) {
      content = content.replaceFirstMapped(
        configMarker,
        (match) => "${match.group(0)}\n  $snakeName.configureModuleDependencies(getIt);",
      );
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateTranslationProviders(String snakeName) async {
  final file = File('lib/core/localization/app_translation_providers.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add import
  if (!content.contains("package:$snakeName/$snakeName.dart")) {
    final importMarker = "import 'package:settings/settings.dart' as settings;";
    content = content.replaceFirst(
      importMarker,
      "$importMarker\nimport 'package:$snakeName/$snakeName.dart' as $snakeName;",
    );
  }

  // Add provider
  if (!content.contains("$snakeName.TranslationProvider")) {
    final providerMarker = "({required child}) => settings.TranslationProvider(child: child),";
    content = content.replaceFirst(
      providerMarker,
      "$providerMarker\n  ({required child}) => $snakeName.TranslationProvider(child: child),",
    );
  }

  await file.writeAsString(content);
}

Future<void> _updateLocalizationInitializer(String snakeName) async {
  final file = File('lib/core/app_initializer/localization_initializer.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  var updated = false;

  // 1. Add import
  if (!content.contains("package:$snakeName/generated/translations.dart")) {
    final importMarker = "import 'package:settings/generated/translations.dart' as settings;";
    if (content.contains(importMarker)) {
      content = content.replaceFirst(
        importMarker,
        "$importMarker\nimport 'package:$snakeName/generated/translations.dart' as $snakeName;",
      );
      updated = true;
    }
  }

  // 2. Add to _registerSyncLocaleCallback
  if (!content.contains("$snakeName.LocaleSettings.setLocaleRaw(rawLocale);")) {
    final syncMarker = "settings.LocaleSettings.setLocaleRaw(rawLocale);";
    if (content.contains(syncMarker)) {
      content = content.replaceFirst(
        syncMarker,
        "$syncMarker\n      $snakeName.LocaleSettings.setLocaleRaw(rawLocale);",
      );
      updated = true;
    }
  }

  // 3. Add to _registerOverrideCallback
  if (!content.contains("await $snakeName.LocaleSettings.overrideTranslationsFromMap")) {
    final settingsBlockRegex = RegExp(
      r"await settings\.LocaleSettings\.overrideTranslationsFromMap\([\s\S]*?\);",
    );
    final match = settingsBlockRegex.firstMatch(content);
    if (match != null) {
      final newBlock = '''
      await $snakeName.LocaleSettings.overrideTranslationsFromMap(
        locale: $snakeName.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'$snakeName': json['$snakeName'] ?? {}},
      );''';

      content = content.replaceFirst(match.group(0)!, "${match.group(0)}\n$newBlock");
      updated = true;
    }
  }

  if (updated) {
    await file.writeAsString(content);
  }
}

Future<void> _updateAppRouter(String snakeName, String pascalName, String camelName) async {
  final file = File('lib/app_router.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add import
  if (!content.contains("package:$snakeName/$snakeName.dart")) {
    final importMarker = "import 'package:settings/settings.dart' as settings;";
    content = content.replaceFirst(
      importMarker,
      "$importMarker\nimport 'package:$snakeName/$snakeName.dart' as $snakeName;",
    );
  }

  // Add export
  if (!content.contains("package:$snakeName/${snakeName}_router.dart")) {
    final exportMarker = "export 'package:settings/settings_router.dart';";
    content = content.replaceFirst(
      exportMarker,
      "$exportMarker\nexport 'package:$snakeName/${snakeName}_router.dart';",
    );
  }

  // Add router instance
  if (!content.contains("final _${camelName}Router")) {
    final instanceMarker = "final _settingsRouter = settings.SettingsRouter();";
    if (content.contains(instanceMarker)) {
      content = content.replaceFirst(
        instanceMarker,
        "$instanceMarker\n  final _${camelName}Router = $snakeName.${pascalName}Router();",
      );
    }
  }

  // Add routes
  if (!content.contains("..._${camelName}Router.routes")) {
    final routesMarker = "..._settingsRouter.routes,";
    if (content.contains(routesMarker)) {
      content = content.replaceFirst(
        routesMarker,
        "$routesMarker\n    ..._${camelName}Router.routes,",
      );
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateFeaturePublicRoutes(
  String snakeName,
  String pascalName,
  String camelName,
) async {
  final file = File('packages/platform/lib/deep_link_routes.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  var updated = false;

  final privateRoutesMarker = '// Private route classes';
  if (content.contains(privateRoutesMarker) &&
      !content.contains('static const String $camelName')) {
    final insertionPoint = content.indexOf(privateRoutesMarker);
    final lastBrace = content.lastIndexOf('}', insertionPoint);

    if (lastBrace != -1) {
      final newRouteConsts = '''

  // $pascalName
  static const String $camelName = '/$camelName';
  static const PageRouteInfo ${camelName}Route = _${pascalName}Route();
''';
      content = content.substring(0, lastBrace) + newRouteConsts + content.substring(lastBrace);
      updated = true;
    }
  }

  if (!content.contains('class _${pascalName}Route extends PageRouteInfo')) {
    final newRouteClass = '''

class _${pascalName}Route extends PageRouteInfo<void> {
  const _${pascalName}Route() : super('${pascalName}Route');
}
''';
    content += newRouteClass;
    updated = true;
  }

  if (updated) {
    await file.writeAsString(content);
  }
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
