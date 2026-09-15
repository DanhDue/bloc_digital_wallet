// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final snakeCaseName = name.snakeCase;

  final packageDir = Directory('packages/$snakeCaseName');
  if (!packageDir.existsSync()) {
    context.logger.err('Package "packages/$snakeCaseName" does not exist.');
    throw ProcessException('mason', [], 'Target package packages/$snakeCaseName does not exist.');
  }

  final androidPresentationDir = Directory(
    'packages/$snakeCaseName/android/src/main/kotlin/com/danhdue/$snakeCaseName/presentation',
  );
  if (androidPresentationDir.existsSync()) {
    context.logger.err('Presentation layer already exists in $snakeCaseName');
    throw ProcessException(
      'mason',
      [],
      'Presentation layer already exists in $snakeCaseName',
    );
  }

  final iosPresentationDir = Directory(
    'packages/$snakeCaseName/ios/$snakeCaseName/Sources/$snakeCaseName/Presentation',
  );
  if (iosPresentationDir.existsSync()) {
    context.logger.err('Presentation layer already exists in $snakeCaseName');
    throw ProcessException(
      'mason',
      [],
      'Presentation layer already exists in $snakeCaseName',
    );
  }
}
