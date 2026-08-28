// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;
  final pascalCaseName = name.pascalCase;
  final camelCaseName = name.camelCase;

  final progress = context.logger.progress('Integrating package $name...');

  try {
    // 1. Update root pubspec.yaml
    await _updateRootPubspec(snakeCaseName);

    // 2. Update lib/di/injection.dart
    await _updateInjection(snakeCaseName, camelCaseName);

    // 3. Update lib/core/localization/app_translation_providers.dart
    await _updateTranslationProviders(snakeCaseName, camelCaseName);

    // 3.5 Update lib/core/app_initializer/localization_initializer.dart
    await _updateLocalizationInitializer(snakeCaseName, camelCaseName);

    // 4. Update lib/app_router.dart
    await _updateAppRouter(snakeCaseName, pascalCaseName, camelCaseName);

    // 5. Update DeepLinkRoutes
    progress.update('Updating DeepLinkRoutes...');
    await _updateFeaturePublicRoutes(snakeCaseName, pascalCaseName, camelCaseName);

    // 6. Update AppUri (for Network Module)
    await _updateAppUri(snakeCaseName, camelCaseName);

    // 7. Run Melos commands
    progress.update('Running melos bootstrap...');
    await _runCommand('melos', ['bootstrap'], context.logger);

    progress.update('Running scoped code generation...');
    await _runCommand('./scripts/integrateFeatureToApp.sh', [snakeCaseName], context.logger);

    progress.complete('Package $name integrated successfully!');
  } catch (e) {
    progress.fail('Failed to integrate package $name: $e');
  }
}

Future<void> _updateRootPubspec(String snakeName) async {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add to workspace
  if (!content.contains("packages/$snakeName")) {
    final workspaceMarker = "workspace:";
    if (content.contains(workspaceMarker)) {
      // Find the end of the workspace list or just append to the last item found
      final workspaceRegex = RegExp(r'workspace:\s*\n(\s+- .*\n)+');
      final match = workspaceRegex.firstMatch(content);

      if (match != null) {
        final currentWorkspaceBlock = match.group(0)!;
        // Check if there is a newline at the end
        final newWorkspaceBlock = currentWorkspaceBlock.endsWith('\n')
            ? "${currentWorkspaceBlock}  - packages/$snakeName\n"
            : "$currentWorkspaceBlock\n  - packages/$snakeName\n";

        content = content.replaceFirst(currentWorkspaceBlock, newWorkspaceBlock);
      }
    }
  }

  // Add to dependencies
  if (!content.contains("$snakeName:")) {
    final dependenciesMarker = "dependencies:";
    if (content.contains(dependenciesMarker)) {
      // We want to add it nicely formatted.
      // Finding a good insertion point: maybe after onboard or just after dependencies:
      final onboardMarker = "path: packages/onboard";
      if (content.contains(onboardMarker)) {
        content = content.replaceFirst(
          onboardMarker,
          "$onboardMarker\n  $snakeName:\n    path: packages/$snakeName",
        );
      } else {
        // Fallback: append to dependencies start
        content = content.replaceFirst(
          dependenciesMarker,
          "$dependenciesMarker\n  $snakeName:\n    path: packages/$snakeName",
        );
      }
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateInjection(String snakeName, String camelName) async {
  final file = File('lib/di/injection.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add import
  if (!content.contains("package:$snakeName/$snakeName.dart")) {
    final importMarker = "import 'package:onboard/onboard.dart' as onboard;";
    if (content.contains(importMarker)) {
      content = content.replaceFirst(
        importMarker,
        "$importMarker\nimport 'package:$snakeName/$snakeName.dart' as $camelName;",
      );
    } else {
      // Fallback if marker not found, try adding after last import
      final lastImport = RegExp(r"import 'package:.*';");
      content = content.replaceFirstMapped(lastImport, (match) {
        return "${match.group(0)}\nimport 'package:$snakeName/$snakeName.dart' as $camelName;";
      });
    }
  }

  // Add dependency configuration
  if (!content.contains("$camelName.configureModuleDependencies(getIt);")) {
    final configMarker = "onboard.configureModuleDependencies(getIt);";
    if (content.contains(configMarker)) {
      content = content.replaceFirst(
        configMarker,
        "$configMarker\n  $camelName.configureModuleDependencies(getIt);",
      );
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateTranslationProviders(String snakeName, String camelName) async {
  final file = File('lib/core/localization/app_translation_providers.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add import
  if (!content.contains("package:$snakeName/$snakeName.dart")) {
    final importMarker = "import 'package:onboard/onboard.dart' as onboard;";
    content = content.replaceFirst(
      importMarker,
      "$importMarker\nimport 'package:$snakeName/$snakeName.dart' as $camelName;",
    );
  }

  // Add provider
  if (!content.contains("$camelName.TranslationProvider")) {
    final providerMarker = "({required child}) => onboard.TranslationProvider(child: child),";
    content = content.replaceFirst(
      providerMarker,
      "$providerMarker\n  ({required child}) => $camelName.TranslationProvider(child: child),",
    );
  }

  await file.writeAsString(content);
}

Future<void> _updateLocalizationInitializer(String snakeName, String camelName) async {
  final file = File('lib/core/app_initializer/localization_initializer.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  var updated = false;

  // 1. Add import
  if (!content.contains("package:$snakeName/generated/translations.dart")) {
    final importMarker = "import 'package:onboard/generated/translations.dart' as onboard;";
    if (content.contains(importMarker)) {
      content = content.replaceFirst(
        importMarker,
        "$importMarker\nimport 'package:$snakeName/generated/translations.dart' as $camelName;",
      );
      updated = true;
    }
  }

  // 2. Add to _registerSyncLocaleCallback
  if (!content.contains("$camelName.LocaleSettings.setLocaleRaw(rawLocale);")) {
    final syncMarker = "onboard.LocaleSettings.setLocaleRaw(rawLocale);";
    if (content.contains(syncMarker)) {
      content = content.replaceFirst(
        syncMarker,
        "$syncMarker\n      $camelName.LocaleSettings.setLocaleRaw(rawLocale);",
      );
      updated = true;
    }
  }

  // 3. Add to _registerOverrideCallback
  if (!content.contains("await $camelName.LocaleSettings.overrideTranslationsFromMap")) {
    final onboardBlockRegex =
        RegExp(r"await onboard\.LocaleSettings\.overrideTranslationsFromMap\([\s\S]*?\);");
    final match = onboardBlockRegex.firstMatch(content);
    if (match != null) {
      final newBlock = '''
      await $camelName.LocaleSettings.overrideTranslationsFromMap(
        locale: $camelName.AppLocaleUtils.parse(rawLocale),
        isFlatMap: false,
        map: {'$snakeName': json['$snakeName'] ?? {}},
      );''';

      content = content.replaceFirst(
        match.group(0)!,
        "${match.group(0)}\n$newBlock",
      );
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
    final importMarker = "import 'package:onboard/onboard.dart' as onboard;";
    content = content.replaceFirst(
      importMarker,
      "$importMarker\nimport 'package:$snakeName/$snakeName.dart' as $camelName;",
    );
  }

  // Add export
  if (!content.contains("package:$snakeName/${snakeName}_router.dart")) {
    final exportMarker = "export 'package:onboard/onboard_router.dart';";
    content = content.replaceFirst(
      exportMarker,
      "$exportMarker\nexport 'package:$snakeName/${snakeName}_router.dart';",
    );
  }

  // Add router instance
  if (!content.contains("final _${camelName}Router")) {
    final instanceMarker = "final _authRouter = auth.AuthenticationRouter();";
    // Note: In previous step logic, it seemed to rely on _authRouter existing.
    // Since we are fixing the logic, we should try to be consistent with what exists.
    // However, if the user mentioned _authRouter in original code, we keep it.

    // Improving the logic to find ANY router definition if auth router is missing, but sticking to existing pattern first.
    if (content.contains(instanceMarker)) {
      content = content.replaceFirst(
        instanceMarker,
        "$instanceMarker\n  final _${camelName}Router = $camelName.${pascalName}Router();",
      );
    }
  }

  // Add routes
  if (!content.contains("..._${camelName}Router.routes")) {
    final routesMarker = "..._authRouter.routes,";
    if (content.contains(routesMarker)) {
      content = content.replaceFirst(
        routesMarker,
        "$routesMarker\n    ..._${camelName}Router.routes,",
      );
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateCommonRoutes(String snakeName, String pascalName, String camelName) async {
  // Use relative path from root since post_gen runs from project root
  final file = File('packages/core/lib/utils/common_routes.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  var updated = false;

  // Add route constant inside CommonRoutes class
  // We locate the closing brace of CommonRoutes class by finding subsequent private class definition
  // or just append before the last closing brace of the main block if we assume standard formatting.
  // A safer bet given the file structure is looking for the comment block of private routes.
  const privateRoutesMarker = '// Private route classes';
  if (content.contains(privateRoutesMarker) &&
      !content.contains('static const String $camelName')) {
    final insertionPoint = content.indexOf(privateRoutesMarker);
    final lastBrace = content.lastIndexOf('}', insertionPoint);

    if (lastBrace != -1) {
      final newRouteConsts = '''\n\n// $pascalName
  static const String $camelName = '/$camelName';
  static const PageRouteInfo ${camelName}Route = _${pascalName}Route();

''';
      content = content.substring(0, lastBrace) + newRouteConsts + content.substring(lastBrace);
      updated = true;
    }
  }

  // Add private route class at the end of file
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

Future<void> _updateFeaturePublicRoutes(
  String snakeName,
  String pascalName,
  String camelName,
) async {
  // Use relative path from root since post_gen runs from project root
  final file = File('packages/platform/lib/deep_link_routes.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();
  var updated = false;

  // Add route constant inside DeepLinkRoutes class
  // We locate the closing brace of FeaturePublicRoutes class by finding subsequent private class definition
  // or just append before the last closing brace of the main block if we assume standard formatting.
  // A safer bet given the file structure is looking for the comment block of private routes.
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

  // Add private route class at the end of file
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

Future<void> _updateAppUri(String snakeName, String camelName) async {
  // Use relative path from root since post_gen runs from project root
  final file = File('packages/network/lib/app_uri.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  if (!content.contains('static const String $camelName')) {
    // Insert before baseUrl which is usually at the end of the list
    final baseUrlMarker = "static const String baseUrl = 'baseUrl';";
    if (content.contains(baseUrlMarker)) {
      content = content.replaceFirst(
        baseUrlMarker,
        "static const String $camelName = '$snakeName';\n  $baseUrlMarker",
      );
      await file.writeAsString(content);
    } else {
      // Fallback: append after class start if baseUrl not found (unlikely)
      final classMarker = "class AppUri {";
      if (content.contains(classMarker)) {
        content = content.replaceFirst(
          classMarker,
          "$classMarker\n  static const String $camelName = '$snakeName';",
        );
        await file.writeAsString(content);
      }
    }
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
