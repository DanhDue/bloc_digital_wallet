// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final appName = (context.vars['app_name'] as String?)?.trim() ?? 'My Super App';
  final packageName = (context.vars['package_name'] as String?)?.trim() ?? 'my_super_app';
  final bundleId = (context.vars['bundle_id'] as String?)?.trim() ?? 'com.example.mysuperapp';

  final progress = context.logger.progress('Renaming project to "$appName" ($packageName)...');

  try {
    final rootDir = Directory.current;

    // 1. Detect old package name from root pubspec.yaml
    final rootPubspecFile = File('${rootDir.path}/pubspec.yaml');
    if (!rootPubspecFile.existsSync()) {
      progress.fail('Could not find pubspec.yaml in current directory.');
      return;
    }

    var pubspecContent = await rootPubspecFile.readAsString();
    final nameRegex = RegExp(r'^name:\s*([a-zA-Z0-9_]+)', multiLine: true);
    final match = nameRegex.firstMatch(pubspecContent);
    final oldPackageName = match?.group(1) ?? 'bloc_digital_wallet';

    // 2. Update pubspec.yaml
    progress.update('Updating pubspec.yaml...');
    pubspecContent = pubspecContent.replaceFirst(
      nameRegex,
      'name: $packageName',
    );
    await rootPubspecFile.writeAsString(pubspecContent);

    // 3. Update melos.yaml
    final melosFile = File('${rootDir.path}/melos.yaml');
    if (melosFile.existsSync()) {
      progress.update('Updating melos.yaml...');
      var melosContent = await melosFile.readAsString();
      melosContent = melosContent.replaceFirst(
        nameRegex,
        'name: $packageName',
      );
      await melosFile.writeAsString(melosContent);
    }

    // 4. Update Dart package imports in lib/, test/, features/, integration_test/
    // CRITICAL: Strictly preserve packages/ (vendor locked)
    progress.update('Updating Dart imports from package:$oldPackageName/ to package:$packageName/...');
    final scanDirs = ['lib', 'test', 'features', 'integration_test'];
    final oldImportPrefix = 'package:$oldPackageName/';
    final newImportPrefix = 'package:$packageName/';

    for (final dirName in scanDirs) {
      final dir = Directory('${rootDir.path}/$dirName');
      if (dir.existsSync()) {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File && entity.path.endsWith('.dart')) {
            final content = await entity.readAsString();
            if (content.contains(oldImportPrefix)) {
              final updated = content.replaceAll(oldImportPrefix, newImportPrefix);
              await entity.writeAsString(updated);
            }
          }
        }
      }
    }

    // 5. Update Android configuration
    progress.update('Updating Android configuration...');
    final buildGradleKts = File('${rootDir.path}/android/app/build.gradle.kts');
    if (buildGradleKts.existsSync()) {
      var gradleContent = await buildGradleKts.readAsString();
      // Replace namespace
      gradleContent = gradleContent.replaceAll(
        RegExp(r'namespace\s*=\s*"[^"]+"'),
        'namespace = "$bundleId"',
      );
      // Replace applicationId
      gradleContent = gradleContent.replaceAll(
        RegExp(r'applicationId\s*=\s*"[^"]+"'),
        'applicationId = "$bundleId"',
      );
      // Replace default app name define
      gradleContent = gradleContent.replaceAll(
        RegExp(r'"DART_DEFINES_APP_NAME"\s*to\s*"[^"]+"'),
        '"DART_DEFINES_APP_NAME" to "$appName"',
      );
      await buildGradleKts.writeAsString(gradleContent);
    }

    // Move & Update MainActivity.kt
    final kotlinBaseDir = Directory('${rootDir.path}/android/app/src/main/kotlin');
    if (kotlinBaseDir.existsSync()) {
      File? mainActivityFile;
      await for (final entity in kotlinBaseDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('MainActivity.kt')) {
          mainActivityFile = entity;
          break;
        }
      }

      if (mainActivityFile != null) {
        var activityContent = await mainActivityFile.readAsString();
        activityContent = activityContent.replaceFirst(
          RegExp(r'^package\s+[\w.]+', multiLine: true),
          'package $bundleId',
        );

        final targetSubpath = bundleId.replaceAll('.', '/');
        final targetDir = Directory('${kotlinBaseDir.path}/$targetSubpath');
        final targetFile = File('${targetDir.path}/MainActivity.kt');

        if (mainActivityFile.path != targetFile.path) {
          if (!targetDir.existsSync()) {
            await targetDir.create(recursive: true);
          }
          await targetFile.writeAsString(activityContent);
          await mainActivityFile.delete();

          // Cleanup empty directories
          var currentParent = mainActivityFile.parent;
          while (currentParent.path != kotlinBaseDir.path &&
              currentParent.existsSync() &&
              currentParent.listSync().isEmpty) {
            await currentParent.delete();
            currentParent = currentParent.parent;
          }
        } else {
          await targetFile.writeAsString(activityContent);
        }
      }
    }

    // 6. Update iOS configuration
    progress.update('Updating iOS configuration...');
    final pbxprojFile = File('${rootDir.path}/ios/Runner.xcodeproj/project.pbxproj');
    if (pbxprojFile.existsSync()) {
      var pbxContent = await pbxprojFile.readAsString();
      // Replace bundle ID
      pbxContent = pbxContent.replaceAll(
        RegExp(r'com\.example\.blocDigitalWallet'),
        bundleId,
      );
      await pbxprojFile.writeAsString(pbxContent);
    }

    final infoPlist = File('${rootDir.path}/ios/Runner/Info.plist');
    if (infoPlist.existsSync()) {
      var plistContent = await infoPlist.readAsString();
      plistContent = plistContent.replaceAll(
        '<string>$oldPackageName</string>',
        '<string>$packageName</string>',
      );
      plistContent = plistContent.replaceAll(
        '<string>bloc_digital_wallet</string>',
        '<string>$packageName</string>',
      );
      await infoPlist.writeAsString(plistContent);
    }

    final verifyFlavors = File('${rootDir.path}/ios/scripts/verify_flavors.sh');
    if (verifyFlavors.existsSync()) {
      var verifyContent = await verifyFlavors.readAsString();
      verifyContent = verifyContent.replaceAll(
        RegExp(r'BASE_ID="[^"]+"'),
        'BASE_ID="$bundleId"',
      );
      await verifyFlavors.writeAsString(verifyContent);
    }

    // Update xcconfig app name definitions
    final flutterConfigDir = Directory('${rootDir.path}/ios/Flutter');
    if (flutterConfigDir.existsSync()) {
      await for (final entity in flutterConfigDir.list()) {
        if (entity is File && entity.path.endsWith('.xcconfig')) {
          var configContent = await entity.readAsString();
          if (configContent.contains('DART_DEFINES_APP_NAME')) {
            if (entity.path.contains('-dev')) {
              configContent = configContent.replaceAll(
                RegExp(r'DART_DEFINES_APP_NAME\s*=.*'),
                'DART_DEFINES_APP_NAME = $appName(dev)',
              );
            } else if (entity.path.contains('-stg')) {
              configContent = configContent.replaceAll(
                RegExp(r'DART_DEFINES_APP_NAME\s*=.*'),
                'DART_DEFINES_APP_NAME = $appName(stg)',
              );
            } else {
              configContent = configContent.replaceAll(
                RegExp(r'DART_DEFINES_APP_NAME\s*=.*'),
                'DART_DEFINES_APP_NAME = $appName',
              );
            }
            await entity.writeAsString(configContent);
          }
        }
      }
    }

    // 7. Melos bootstrap and code generation
    progress.update('Running melos bootstrap...');
    final bootstrapResult = await Process.run('melos', ['bootstrap'], runInShell: true);
    if (bootstrapResult.exitCode != 0) {
      context.logger.warn('melos bootstrap warning: ${bootstrapResult.stderr}');
    }

    final genAllsScript = File('${rootDir.path}/scripts/genAlls.sh');
    if (genAllsScript.existsSync()) {
      progress.update('Running ./scripts/genAlls.sh (slang, build_runner, analyze)...');
      final genResult = await Process.run('bash', ['scripts/genAlls.sh'], runInShell: true);
      if (genResult.exitCode != 0) {
        context.logger.warn('scripts/genAlls.sh warning: ${genResult.stderr}');
      }
    }

    progress.complete('Project successfully renamed to "$appName" ($packageName)!');
  } catch (e, st) {
    progress.fail('Failed to rename project: $e\n$st');
  }
}
