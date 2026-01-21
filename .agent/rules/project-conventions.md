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
*   ✅ **Correct**: `TokenClient(dio, baseUrl: AppUri.tokenAccounts.buildAppUri()!)`
*   ❌ **Incorrect**: `TokenClient(dio)`
*   **Reason**: Dio's default `baseUrl` may point to a different microservice. Explicitly setting it in `NetworkModule` ensures the client hits the correct endpoint.

## 4. Dart Syntax Shorthands
*   ❌ **Rule**: Use Dart's dot shorthands where context allows.
*   ✅ **Correct**: `.infinity`, `.maxFinite`, `.zero`
*   ❌ **Incorrect**: `double.infinity`, `double.maxFinite`, `Offset.zero` (when type is inferred)
*   **Reason**: Cleaner, more modern Dart syntax.
## 5. Formatting Standards
*   ❌ **Rule**: **Line Length** MUST be set to **99 characters**.
*   ✅ **Correct**: `dart format -l 99`
*   ❌ **Incorrect**: `80` (Standard) or `100+`
*   **Reason**: Consistency across larger monitors while maintaining readability.
