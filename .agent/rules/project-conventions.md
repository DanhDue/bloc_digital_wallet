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

## 3. Dart Syntax Shorthands
*   ❌ **Rule**: Use Dart's dot shorthands where context allows.
*   ✅ **Correct**: `.infinity`, `.maxFinite`, `.zero`
*   ❌ **Incorrect**: `double.infinity`, `double.maxFinite`, `Offset.zero` (when type is inferred)
*   **Reason**: Cleaner, more modern Dart syntax.
