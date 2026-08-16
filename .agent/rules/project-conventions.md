---
trigger: always_on
---

# Project Conventions (Strict)

> [!CRITICAL]
> These rules are MANDATORY for all code. Deviations will be rejected.

## 1. Import Paths
*   ❌ **Rule**: **NEVER** use relative imports for `lib/` files.
*   ✅ **Correct**: `import 'package:bloc_digital_wallet/core/utils.dart';`
*   ❌ **Incorrect**: `import '../../core/utils.dart';`
*   **Reason**: Ensures refactoring safety and prevents import cycles.

## 2. Models & Entities (Freezed)
*   ❌ **Rule**: All data classes MUST use `freezed`.
*   ❌ **Rule**: **ONE OBJECT, ONE FILE**. Each class (Root or Nested) MUST have its own dedicated `.dart` file.
*   ✅ **Requirement 1**: Must be an `abstract class`.
*   ✅ **Requirement 2**: MUST use `@JsonKey(name: 'field_name')` for ALL fields to ensure backend compatibility.
*   ✅ **Requirement 3**: MUST use `@JsonSerializable(includeIfNull: false)` (via `build.yaml` or explicit annotation).
*   ✅ **Requirement 4**: MUST import "import 'package:freezed_annotation/freezed_annotation.dart';".

**Example:**
```dart
@freezed
class Token with _$Token {
  const factory Token({
    @JsonKey(name: 'token_id') required String tokenId,
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
```

## 3. Networking & DI (Retrofit)
*   ❌ **Rule**: **NEVER** instantiate a Retrofit client without an explicit `baseUrl`.
*   ✅ **Correct**: `TokenClient(dio, baseUrl: WalletUri.tokens.buildAppUri()!)`
*   ❌ **Incorrect**: `TokenClient(dio)`
*   **Reason**: Dio's default `baseUrl` may point to a different microservice. Explicitly setting it in `NetworkModule` ensures the client hits the correct endpoint.

## 4. Decentralized AppUri & Path Parameters
*   ❌ **Rule**: **NEVER** add feature-specific URI constants or path parameters to the global `network/app_uri.dart`.
*   ✅ **Correct**: Each module MUST define its own URI class at `data/datasources/remote/{name}_uri.dart` (e.g., `WalletUri`, `ScannerUri`).
*   ✅ **Correct**: Feature-specific path parameters (like `/{address}` or `/{signature}`) must also be defined in the module's URI class (e.g., `WalletUri.pathAddress`), NOT in a global `UriPathParameters` class.
*   ❌ **Incorrect**: Adding `static const String myFeature = 'my_feature';` to `AppUri` or adding `static const String id = '/{id}';` to a global `UriPathParameters` class.
*   **Reason**: `network` package is infrastructure — it must not know about feature modules. Decentralizing AppUri ensures each module owns its URI constants and prevents the `network` package from becoming a bottleneck god class.

## 5. Dart Syntax Shorthands
*   ❌ **Rule**: Use Dart's dot shorthands where context allows.
*   ✅ **Correct**: `.infinity`, `.maxFinite`, `.zero`
*   ❌ **Incorrect**: `double.infinity`, `double.maxFinite`, `Offset.zero` (when type is inferred)
*   **Reason**: Cleaner, more modern Dart syntax.
## 6. Formatting Standards
*   ❌ **Rule**: **Line Length** MUST be set to **99 characters**.
*   ✅ **Correct**: `dart format -l 99`
*   ❌ **Incorrect**: `80` (Standard) or `100+`
*   **Reason**: Consistency across larger monitors while maintaining readability.
