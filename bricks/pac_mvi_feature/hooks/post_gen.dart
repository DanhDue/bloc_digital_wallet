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
    // 1. Update lib/di/injection.dart
    await _updateInjection(snakeCaseName, camelCaseName);

    // 2. Update lib/core/localization/app_translation_providers.dart
    await _updateTranslationProviders(snakeCaseName, camelCaseName);

    // 3. Update lib/app_router.dart
    await _updateAppRouter(snakeCaseName, pascalCaseName, camelCaseName);

    progress.complete('Package $name integrated successfully!');
  } catch (e) {
    progress.fail('Failed to integrate package $name: $e');
  }
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
    final instanceMarker =
        "final _authRouter = auth.AuthenticationRouter();"; // Assuming this exists based on step 8
    // But step 8 showed: `final _authRouter = auth.AuthenticationRouter();`
    // Wait, checking Step 8 output again.
    // 17:   final _authRouter = auth.AuthenticationRouter();

    content = content.replaceFirst(
      instanceMarker,
      "$instanceMarker\n  final _${camelName}Router = $camelName.${pascalName}Router();",
    );
  }

  // Add routes
  if (!content.contains("..._${camelName}Router.routes")) {
    // Step 8 showed: `    ..._authRouter.routes,`
    final routesMarker = "..._authRouter.routes,";
    content = content.replaceFirst(
      routesMarker,
      "$routesMarker\n    ..._${camelName}Router.routes,",
    );
  }

  await file.writeAsString(content);
}
