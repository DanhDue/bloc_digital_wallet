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
  final camelPackage = packageName.camelCase;
  final camelSubfeature = subfeatureName.camelCase;

  final progress = context.logger.progress('Integrating subfeature...');

  try {
    // 1. Add method to parent's repository interface
    await _updateRepositoryInterface(
      snakePackage,
      snakeSubfeature,
      pascalPackage,
      pascalSubfeature,
    );

    // 2. Add method to parent's repository implementation
    await _updateRepositoryImpl(snakePackage, snakeSubfeature, pascalPackage, pascalSubfeature);

    // 3. Add method to parent's remote datasource
    await _updateRemoteDataSource(snakePackage, snakeSubfeature, pascalPackage, pascalSubfeature);

    // 4. Add endpoint to parent's client
    await _updateClient(snakePackage, snakeSubfeature, pascalPackage, pascalSubfeature);

    // 5. Update {package}_router.dart to add route
    await _updateRouter(
      snakePackage,
      snakeSubfeature,
      pascalSubfeature,
      camelSubfeature,
      pascalPackage,
      camelPackage,
    );

    // 6. Update {package}.dart to export new subfeature files
    await _updatePackageExports(snakePackage, snakeSubfeature, pascalSubfeature);

    // 7. Update di/injection.dart to register bloc
    await _updateDI(snakePackage, snakeSubfeature, pascalSubfeature);

    progress.complete('Subfeature $subfeatureName integrated into $packageName!');

    // Only rebuild the affected package
    context.logger.info('Rebuilding $snakePackage package...');
    final result = await Process.run('melos', [
      'exec',
      '--scope=$snakePackage',
      '--',
      'fvm',
      'flutter',
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ], runInShell: true);
    if (result.exitCode == 0) {
      context.logger.success('Rebuild completed successfully.');
    } else {
      context.logger.err('Package rebuild failed: ${result.stderr}');
    }
  } catch (e) {
    progress.fail('Failed to integrate subfeature: $e');
  }
}

/// Add method to parent's repository interface
Future<void> _updateRepositoryInterface(
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

  // Check if method already exists
  if (content.contains('get$pascalSubfeature()')) return;

  // Add import for entity
  final entityImport =
      "import 'package:$snakePackage/domain/entities/${snakeSubfeature}_entity.dart';";
  if (!content.contains(entityImport)) {
    final lastImport = content.lastIndexOf("import '");
    if (lastImport != -1) {
      final endOfImport = content.indexOf(';', lastImport);
      content = content.substring(0, endOfImport + 1) +
          '\n$entityImport' +
          content.substring(endOfImport + 1);
    }
  }

  // Add method declaration before the closing brace
  final classPattern = RegExp(r'abstract\s+class\s+' + pascalPackage + r'Repository\s*\{');
  if (classPattern.hasMatch(content)) {
    final lastBrace = content.lastIndexOf('}');
    if (lastBrace != -1) {
      final newMethod =
          '  Future<Either<Failure, ${pascalSubfeature}Entity>> get$pascalSubfeature();\n';
      content = content.substring(0, lastBrace) + newMethod + content.substring(lastBrace);
    }
  }

  await file.writeAsString(content);
}

/// Add method to parent's repository implementation
Future<void> _updateRepositoryImpl(
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

  // Check if method already exists
  if (content.contains('get$pascalSubfeature()')) return;

  // Add import for entity
  final entityImport =
      "import 'package:$snakePackage/domain/entities/${snakeSubfeature}_entity.dart';";
  if (!content.contains(entityImport)) {
    final lastImport = content.lastIndexOf("import '");
    if (lastImport != -1) {
      final endOfImport = content.indexOf(';', lastImport);
      content = content.substring(0, endOfImport + 1) +
          '\n$entityImport' +
          content.substring(endOfImport + 1);
    }
  }

  // Add method implementation before the closing brace
  final classPattern = RegExp(r'class\s+' + pascalPackage + r'RepositoryImpl');
  if (classPattern.hasMatch(content)) {
    final lastBrace = content.lastIndexOf('}');
    if (lastBrace != -1) {
      final newMethod = '''

  @override
  Future<Either<Failure, ${pascalSubfeature}Entity>> get$pascalSubfeature() {
    return _remoteDataSource.get$pascalSubfeature();
  }
''';
      content = content.substring(0, lastBrace) + newMethod + content.substring(lastBrace);
    }
  }

  await file.writeAsString(content);
}

/// Add method to parent's remote datasource
Future<void> _updateRemoteDataSource(
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

  // Check if method already exists
  if (content.contains('get$pascalSubfeature()')) return;

  // Add import for model and entity
  final modelImport = "import 'package:$snakePackage/data/models/${snakeSubfeature}_model.dart';";
  final entityImport =
      "import 'package:$snakePackage/domain/entities/${snakeSubfeature}_entity.dart';";

  if (!content.contains(modelImport)) {
    final lastImport = content.lastIndexOf("import '");
    if (lastImport != -1) {
      final endOfImport = content.indexOf(';', lastImport);
      content = content.substring(0, endOfImport + 1) +
          '\n$modelImport' +
          content.substring(endOfImport + 1);
    }
  }

  if (!content.contains(entityImport)) {
    final lastImport = content.lastIndexOf("import '");
    if (lastImport != -1) {
      final endOfImport = content.indexOf(';', lastImport);
      content = content.substring(0, endOfImport + 1) +
          '\n$entityImport' +
          content.substring(endOfImport + 1);
    }
  }

  // Add method before the closing brace of the class
  final classPattern = RegExp(r'class\s+' + pascalPackage + r'RemoteDataSource');
  if (classPattern.hasMatch(content)) {
    final lastBrace = content.lastIndexOf('}');
    if (lastBrace != -1) {
      final newMethod = '''

  Future<Either<Failure, ${pascalSubfeature}Entity>> get$pascalSubfeature() async {
    final result = await safeApiCall(() => _client.get$pascalSubfeature());
    return result.map((model) => model.toEntity());
  }
''';
      content = content.substring(0, lastBrace) + newMethod + content.substring(lastBrace);
    }
  }

  await file.writeAsString(content);
}

/// Add endpoint to parent's client
Future<void> _updateClient(
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

  // Check if method already exists
  if (content.contains('get$pascalSubfeature()')) return;

  // Add import for model
  final modelImport = "import 'package:$snakePackage/data/models/${snakeSubfeature}_model.dart';";
  if (!content.contains(modelImport)) {
    final lastImport = content.lastIndexOf("import '");
    if (lastImport != -1) {
      final endOfImport = content.indexOf(';', lastImport);
      content = content.substring(0, endOfImport + 1) +
          '\n$modelImport' +
          content.substring(endOfImport + 1);
    }
  }

  // Add endpoint before the closing brace of the class
  final classPattern = RegExp(r'abstract\s+class\s+' + pascalPackage + r'Client');
  if (classPattern.hasMatch(content)) {
    final lastBrace = content.lastIndexOf('}');
    if (lastBrace != -1) {
      final newEndpoint = '''

  @GET('/$snakeSubfeature')
  Future<${pascalSubfeature}Model> get$pascalSubfeature();
''';
      content = content.substring(0, lastBrace) + newEndpoint + content.substring(lastBrace);
    }
  }

  await file.writeAsString(content);
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

Future<void> _updatePackageExports(
  String snakePackage,
  String snakeSubfeature,
  String pascalSubfeature,
) async {
  final file = File('packages/$snakePackage/lib/$snakePackage.dart');
  if (!file.existsSync()) return;

  var content = await file.readAsString();

  // Add exports for subfeature
  final exports = [
    "export 'domain/entities/${snakeSubfeature}_entity.dart';",
    "export 'domain/usecases/get_${snakeSubfeature}_usecase.dart';",
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
