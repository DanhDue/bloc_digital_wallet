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

  final progress = context.logger.progress('Integrating subfeature...');

  try {
    // 1. Update {package}_router.dart to add route
    // 1. Update {package}_router.dart to add route
    final pascalPackage = packageName.pascalCase;
    final camelPackage = packageName.camelCase;
    await _updateRouter(
      snakePackage,
      snakeSubfeature,
      pascalSubfeature,
      camelSubfeature,
      pascalPackage,
      camelPackage,
    );

    // 2. Update {package}.dart to export new subfeature files
    await _updatePackageExports(snakePackage, snakeSubfeature);

    // 3. Update di/injection.dart to register bloc
    await _updateDI(snakePackage, snakeSubfeature, pascalSubfeature);

    progress.complete('Subfeature $subfeatureName integrated into $packageName!');

    context.logger.info('Running melos genAlls to update router and DI...');
    final result = await Process.run('melos', ['genAlls'], runInShell: true);
    if (result.exitCode == 0) {
      context.logger.success('melos genAlls completed successfully.');
    } else {
      context.logger.err('melos genAlls failed: ${result.stderr}');
    }
  } catch (e) {
    progress.fail('Failed to integrate subfeature: $e');
  }
}

Future<void> _updateRouter(
  String snakePackage,
  String snakeSubfeature,
  String pascalSubfeature,
  String camelSubfeature,
  String pascalPackage,
  String camelPackage,
) async {
  final file = File('packages/$snakePackage/lib/${snakePackage}_router.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add import for subfeature page
  if (!content.contains("${snakeSubfeature}_page.dart")) {
    final importMarker = RegExp(r"import 'package:");
    final match = importMarker.firstMatch(content);
    if (match != null) {
      content = content.replaceFirst(
        match.group(0)!,
        "import 'package:$snakePackage/presentation/$snakeSubfeature/${snakeSubfeature}_page.dart';\n${match.group(0)}",
      );
    }
  }

  // Handle Routes class
  if (!content.contains("class ${pascalPackage}Routes")) {
    content +=
        "\n\nclass ${pascalPackage}Routes {\n  static const String $camelSubfeature = '\$$camelPackage/$snakeSubfeature';\n}";
  } else if (!content.contains("String $camelSubfeature =")) {
    final routesClassMarker = RegExp(r"class\s+" + pascalPackage + r"Routes\s*\{");
    final match = routesClassMarker.firstMatch(content);
    if (match != null) {
      content = content.replaceFirst(
        match.group(0)!,
        "${match.group(0)!}\n  static const String $camelSubfeature = '\$$camelPackage/$snakeSubfeature';",
      );
    }
  }

  // Add route to routes list
  if (!content.contains("${pascalSubfeature}Route")) {
    final routesMarker = RegExp(r"List<AutoRoute> get routes => \[");
    if (routesMarker.hasMatch(content)) {
      content = content.replaceFirst(
        routesMarker,
        "List<AutoRoute> get routes => [\n    AutoRoute(page: ${pascalSubfeature}Route.page, path: ${pascalPackage}Routes.$camelSubfeature),",
      );
    }
  }

  await file.writeAsString(content);
}

Future<void> _updatePackageExports(String snakePackage, String snakeSubfeature) async {
  final file = File('packages/$snakePackage/lib/$snakePackage.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add exports for subfeature
  final exports = [
    "export 'presentation/$snakeSubfeature/${snakeSubfeature}_action.dart';",
    "export 'presentation/$snakeSubfeature/${snakeSubfeature}_bloc.dart';",
    "export 'presentation/$snakeSubfeature/${snakeSubfeature}_event.dart';",
    "export 'presentation/$snakeSubfeature/${snakeSubfeature}_page.dart';",
    "export 'presentation/$snakeSubfeature/${snakeSubfeature}_state.dart';",
  ];

  for (final export in exports) {
    if (!content.contains(export)) {
      content += '\n$export';
    }
  }

  await file.writeAsString(content);
}

Future<void> _updateDI(
  String snakePackage,
  String snakeSubfeature,
  String pascalSubfeature,
) async {
  // DI is auto-registered with @injectable, no manual changes needed
  // This is a placeholder for future customization if needed
}
