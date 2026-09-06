// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final hasUi = context.vars['has_ui'] as bool? ?? false;
  final snakeCaseName = name.snakeCase;

  final progress = context.logger.progress('Configuring native plugin $name...');

  try {
    // 1. Cleanup directories based on has_ui flag
    if (!hasUi) {
      final androidPresentation = Directory(
        'packages/$snakeCaseName/android/src/main/kotlin/com/danhdue/$snakeCaseName/presentation',
      );
      if (androidPresentation.existsSync()) {
        androidPresentation.deleteSync(recursive: true);
      }
      final iosPresentation = Directory('packages/$snakeCaseName/ios/Classes/Presentation');
      if (iosPresentation.existsSync()) {
        iosPresentation.deleteSync(recursive: true);
      }
      final dartUi = Directory('packages/$snakeCaseName/lib/src/ui');
      if (dartUi.existsSync()) {
        dartUi.deleteSync(recursive: true);
      }
    } else {
      final pigeonsDir = Directory('packages/$snakeCaseName/pigeons');
      if (pigeonsDir.existsSync()) {
        pigeonsDir.deleteSync(recursive: true);
      }
      final messagesDart = File('packages/$snakeCaseName/lib/src/messages.g.dart');
      if (messagesDart.existsSync()) {
        messagesDart.deleteSync();
      }
      final messagesKt = File(
        'packages/$snakeCaseName/android/src/main/kotlin/com/danhdue/$snakeCaseName/Messages.g.kt',
      );
      if (messagesKt.existsSync()) {
        messagesKt.deleteSync();
      }
      final messagesSwift = File('packages/$snakeCaseName/ios/Classes/Messages.g.swift');
      if (messagesSwift.existsSync()) {
        messagesSwift.deleteSync();
      }
    }

    // 2. Update root pubspec.yaml workspace
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

    // 3. Run melos bootstrap
    progress.update('Running melos bootstrap...');
    final result = await Process.run('melos', ['bootstrap'], runInShell: true);
    if (result.exitCode != 0) {
      context.logger.err('melos bootstrap failed: ${result.stderr}');
    }

    progress.complete('Native plugin $name created and registered successfully!');
  } catch (e) {
    progress.fail('Failed to register native plugin $name: $e');
  }
}
