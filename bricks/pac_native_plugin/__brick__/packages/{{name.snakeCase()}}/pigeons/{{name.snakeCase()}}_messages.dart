import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    kotlinOut: 'android/src/main/kotlin/com/danhdue/{{name.snakeCase()}}/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.danhdue.{{name.snakeCase()}}'),
    swiftOut: 'ios/Classes/Messages.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
@HostApi()
abstract class {{name.pascalCase()}}HostApi {
  String getPlatformVersion();
}
