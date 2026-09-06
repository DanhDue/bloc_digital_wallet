// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;

  final progress = context.logger.progress('Registering library $name...');

  try {
    // 1. Update root pubspec.yaml workspace
    final file = File('pubspec.yaml');
    if (file.existsSync()) {
      var content = await file.readAsString();
      if (!content.contains("packages/$snakeCaseName")) {
        final workspaceMarker = "workspace:";
        if (content.contains(workspaceMarker)) {
          final workspaceRegex = RegExp(r'workspace:\s*\n(\s+- .*\n)+');
          final match = workspaceRegex.firstMatch(content);
          if (match != null) {
            final currentWorkspaceBlock = match.group(0)!;
            final newWorkspaceBlock = currentWorkspaceBlock.endsWith('\n')
                ? "${currentWorkspaceBlock}  - packages/$snakeCaseName\n"
                : "$currentWorkspaceBlock\n  - packages/$snakeCaseName\n";
            content = content.replaceFirst(currentWorkspaceBlock, newWorkspaceBlock);
            await file.writeAsString(content);
          }
        }
      }
    }

    // 2. Run melos bootstrap
    progress.update('Running melos bootstrap...');
    final result = await Process.run('melos', ['bootstrap'], runInShell: true);
    if (result.exitCode != 0) {
      context.logger.err('melos bootstrap failed: ${result.stderr}');
    }

    progress.complete('Library $name created and registered successfully!');
  } catch (e) {
    progress.fail('Failed to register library $name: $e');
  }
}
