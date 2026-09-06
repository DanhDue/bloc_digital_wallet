// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;
  final pascalCaseName = name.pascalCase;

  final progress = context.logger.progress('Wiring native UI for $name...');

  try {
    // 1. Patch Android build.gradle
    final buildGradle = File('packages/$snakeCaseName/android/build.gradle');
    if (buildGradle.existsSync()) {
      var content = await buildGradle.readAsString();
      if (!content.contains('compose true') && !content.contains('compose = true')) {
        final composeBlock = '''
    buildFeatures {
        compose true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.15"
    }
''';
        if (content.contains('sourceSets {')) {
          content = content.replaceFirst('sourceSets {', '$composeBlock\n    sourceSets {');
        }
      }

      if (!content.contains('androidx.compose.material3')) {
        final composeDeps = '''
        implementation platform('androidx.compose:compose-bom:2024.09.00')
        implementation 'androidx.compose.ui:ui'
        implementation 'androidx.compose.material3:material3'
        implementation 'androidx.compose.ui:ui-tooling-preview'
        implementation 'androidx.activity:activity-compose:1.9.2'
        implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.5'
''';
        if (content.contains("testImplementation 'junit:junit:4.13.2'")) {
          content = content.replaceFirst(
            "testImplementation 'junit:junit:4.13.2'",
            "$composeDeps        testImplementation 'junit:junit:4.13.2'",
          );
        }
      }
      await buildGradle.writeAsString(content);
    }

    // 2. Patch Android Plugin.kt
    final androidPlugin = File(
      'packages/$snakeCaseName/android/src/main/kotlin/com/danhdue/$snakeCaseName/${pascalCaseName}Plugin.kt',
    );
    if (androidPlugin.existsSync()) {
      var content = await androidPlugin.readAsString();
      if (!content.contains('${pascalCaseName}PlatformViewFactory')) {
        // Add imports
        final importBlock = '''
import com.danhdue.$snakeCaseName.presentation.${pascalCaseName}PlatformViewFactory
import com.danhdue.$snakeCaseName.presentation.${pascalCaseName}ViewModel
''';
        if (content.contains('package com.danhdue.')) {
          final pkgLineEnd = content.indexOf('\n', content.indexOf('package com.danhdue.'));
          content = content.substring(0, pkgLineEnd + 1) +
              importBlock +
              content.substring(pkgLineEnd + 1);
        }

        // Add registration inside onAttachedToEngine
        final factoryRegistration = '''
        val viewModel = ${pascalCaseName}ViewModel()
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "com.danhdue.$snakeCaseName/native_view",
            ${pascalCaseName}PlatformViewFactory(viewModel)
        )
''';
        if (content.contains(
            'override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {')) {
          content = content.replaceFirst(
            'override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {',
            'override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {\n$factoryRegistration',
          );
        }
        await androidPlugin.writeAsString(content);
      }
    }

    // 3. Patch iOS Plugin.swift
    final iosPlugin = File('packages/$snakeCaseName/ios/Classes/${pascalCaseName}Plugin.swift');
    if (iosPlugin.existsSync()) {
      var content = await iosPlugin.readAsString();
      if (!content.contains('${pascalCaseName}PlatformViewFactory')) {
        final factoryRegistration = '''
        let viewModel = ${pascalCaseName}ViewModel()
        let factory = ${pascalCaseName}PlatformViewFactory(viewModel: viewModel)
        registrar.register(factory, withId: "com.danhdue.$snakeCaseName/native_view")
''';
        if (content
            .contains('public static func register(with registrar: FlutterPluginRegistrar) {')) {
          content = content.replaceFirst(
            'public static func register(with registrar: FlutterPluginRegistrar) {',
            'public static func register(with registrar: FlutterPluginRegistrar) {\n$factoryRegistration',
          );
        }
        await iosPlugin.writeAsString(content);
      }
    }

    // 4. Patch Dart entrypoint lib/<name>.dart
    final dartEntry = File('packages/$snakeCaseName/lib/$snakeCaseName.dart');
    if (dartEntry.existsSync()) {
      var content = await dartEntry.readAsString();
      final exportStmt = "export 'src/ui/${snakeCaseName}_native_view.dart';";
      if (!content.contains(exportStmt)) {
        content = content.trimRight() + '\n' + exportStmt + '\n';
        await dartEntry.writeAsString(content);
      }
    }

    // 5. Run melos bootstrap
    progress.update('Running melos bootstrap...');
    final result = await Process.run('melos', ['bootstrap'], runInShell: true);
    if (result.exitCode != 0) {
      context.logger.err('melos bootstrap failed: ${result.stderr}');
    }

    progress.complete('Native UI added to $name successfully!');
  } catch (e) {
    progress.fail('Failed to add native UI to $name: $e');
  }
}
