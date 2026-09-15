// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final hasUi = context.vars['has_ui'] as bool? ?? false;
  final snakeCaseName = name.snakeCase;
  final pkg = 'packages/$snakeCaseName';
  final iosSources = '$pkg/ios/$snakeCaseName/Sources/$snakeCaseName';

  final progress = context.logger.progress('Configuring native plugin $name...');

  try {
    // 1. Cleanup by has_ui.
    if (!hasUi) {
      // Headless: drop the native-UI surface (Android + iOS + Dart).
      for (final dir in [
        Directory('$pkg/android/src/main/kotlin/com/danhdue/$snakeCaseName/presentation'),
        Directory('$pkg/android/src/test/kotlin/com/danhdue/$snakeCaseName/presentation'),
        Directory('$iosSources/Presentation'),
        Directory('$pkg/lib/src/ui'),
      ]) {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      }
      // PlatformViewFactory belongs to the has_ui path only.
      final androidFactory = File(
        '$pkg/android/src/main/kotlin/com/danhdue/$snakeCaseName/platform/${name.pascalCase}PlatformViewFactory.kt',
      );
      if (androidFactory.existsSync()) androidFactory.deleteSync();
      final iosFactory = File('$iosSources/Platform/${name.pascalCase}PlatformViewFactory.swift');
      if (iosFactory.existsSync()) iosFactory.deleteSync();
    } else {
      // Native UI: drop the Pigeon/headless surface.
      for (final f in [
        Directory('$pkg/pigeons'),
        File('$pkg/lib/src/messages.g.dart'),
        File('$pkg/android/src/main/kotlin/com/danhdue/$snakeCaseName/platform/Messages.g.kt'),
        File('$pkg/android/src/main/kotlin/com/danhdue/$snakeCaseName/platform/${name.pascalCase}HostApiImpl.kt'),
        File('$pkg/android/src/test/kotlin/com/danhdue/$snakeCaseName/platform/${name.pascalCase}HostApiImplTest.kt'),
        File('$iosSources/Messages.g.swift'),
        File('$iosSources/Platform/${name.pascalCase}HostApiImpl.swift'),
      ]) {
        if (f.existsSync()) f.deleteSync(recursive: true);
      }
    }

    // 2. Register the package path in the root Dart workspace.
    final file = File('pubspec.yaml');
    if (file.existsSync()) {
      var content = await file.readAsString();
      if (!content.contains('packages/$snakeCaseName')) {
        final workspaceRegex = RegExp(r'workspace:\s*\n(\s+- .*\n)+');
        final match = workspaceRegex.firstMatch(content);
        if (match != null) {
          final block = match.group(0)!;
          final newBlock = block.endsWith('\n')
              ? '$block  - packages/$snakeCaseName\n'
              : '$block\n  - packages/$snakeCaseName\n';
          content = content.replaceFirst(block, newBlock);
          await file.writeAsString(content);
        }
      }
    }

    // 3. Bootstrap the workspace, then `flutter pub get` so Flutter picks up
    //    the new SPM plugin (Package.swift discovery).
    progress.update('Running melos bootstrap...');
    final bootstrap = await Process.run('melos', ['bootstrap'], runInShell: true);
    if (bootstrap.exitCode != 0) {
      context.logger.err('melos bootstrap failed: ${bootstrap.stderr}');
    }
    progress.update('Running flutter pub get...');
    final pubGet = await Process.run('fvm', ['flutter', 'pub', 'get'], runInShell: true);
    if (pubGet.exitCode != 0) {
      // Non-fatal: `fvm` may be absent; the next `flutter` invocation resolves it.
      context.logger.warn('flutter pub get skipped/failed: ${pubGet.stderr}');
    }

    progress.complete('Native plugin $name created and registered successfully!');
    context.logger.info(
      'iOS: SPM-only (no .podspec). Needs a host with '
      '`flutter config --enable-swift-package-manager`. '
      'DI: FactoryKit via ${name.pascalCase}Container.',
    );
  } catch (e) {
    progress.fail('Failed to register native plugin $name: $e');
  }
}
