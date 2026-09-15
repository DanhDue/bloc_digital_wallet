// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    kotlinOut: 'android/src/main/kotlin/com/danhdue/{{name.snakeCase()}}/platform/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.danhdue.{{name.snakeCase()}}.platform'),
    swiftOut: 'ios/{{name.snakeCase()}}/Sources/{{name.snakeCase()}}/Messages.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)

class Pigeon{{name.pascalCase()}}Data {
  final String id;
  final String title;
  final int timestamp;

  Pigeon{{name.pascalCase()}}Data({
    required this.id,
    required this.title,
    required this.timestamp,
  });
}

@HostApi()
abstract class {{name.pascalCase()}}HostApi {
  String getPlatformVersion();

  @async
  Pigeon{{name.pascalCase()}}Data getData();
}
