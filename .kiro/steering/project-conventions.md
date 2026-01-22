---
title: Project Conventions
description: Critical project-specific conventions and constraints
inclusion: always
---

# Project Conventions

> [!CRITICAL]
> These conventions are MANDATORY for all code in this project.

## Import Convention

**ALWAYS use full package paths:**

```dart
// ✅ Correct
import 'package:bloc_digital_wallet/core/network/app_uri.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';

// ❌ Wrong
import '../../core/network/app_uri.dart';
import '../domain/entities/wallet_entity.dart';
```

## Freezed Models Convention

**ALL entities and models MUST use:**
- `@freezed` annotation
- `abstract class` with `_$ClassName` mixin pattern
- `@JsonKey(name: 'field_name')` for EVERY field
- Proper imports for `freezed_annotation` and `foundation.dart`

### Entity Example
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'wallet_entity.freezed.dart';
part 'wallet_entity.g.dart';

@freezed
abstract class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'balance') required double balance,
    @JsonKey(name: 'currency') required String currency,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, Object?> json) =>
      _$WalletEntityFromJson(json);
}
```

### Model Example
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'balance') required double balance,
    @JsonKey(name: 'currency') required String currency,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, Object?> json) =>
      _$WalletModelFromJson(json);
}

extension WalletModelX on WalletModel {
  WalletEntity toEntity() => WalletEntity(
        id: id,
        balance: balance,
        currency: currency,
      );
}
```

## One Object, One File

**Each Freezed class MUST be in its own file:**

```
// ✅ Correct
lib/features/wallet/domain/entities/
├── wallet_entity.dart          # Contains WalletEntity only
├── transaction_entity.dart     # Contains TransactionEntity only
└── balance_entity.dart         # Contains BalanceEntity only

// ❌ Wrong
lib/features/wallet/domain/entities/
└── wallet_entities.dart        # Contains multiple entities
```

## Retrofit Client Convention

**ALWAYS specify explicit baseUrl:**

```dart
// ✅ Correct
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class WalletApiClient {
  factory WalletApiClient(Dio dio, {String baseUrl}) = _WalletApiClient;
  
  @GET('/wallets')
  Future<List<WalletModel>> getWallets();
}

// ❌ Wrong
@RestApi()  // Missing baseUrl
abstract class WalletApiClient {
  // ...
}
```

## Enum Dot Shorthands

**Use dot notation for enums and static members:**

```dart
// ✅ Preferred
BoxFit fit = .contain;
BlendMode mode = .srcIn;
BottomNavigationBarType type = .fixed;
MainAxisAlignment alignment = .center;

// ❌ Avoid (verbose)
BoxFit fit = BoxFit.contain;
BlendMode mode = BlendMode.srcIn;
BottomNavigationBarType type = BottomNavigationBarType.fixed;
MainAxisAlignment alignment = MainAxisAlignment.center;
```

## Theme Usage

**ALWAYS use `context.appThemes` - NEVER hardcode colors:**

```dart
// ✅ Correct
Container(
  color: context.appThemes.primaryColor,
  child: Text(
    'Hello',
    style: context.appThemes.bodyMedium,
  ),
)

// ❌ Wrong
Container(
  color: Colors.blue,  // Hardcoded
  child: Text(
    'Hello',
    style: TextStyle(color: Color(0xFF6200EE)),  // Hardcoded
  ),
)
```

## Localization Usage

**ALWAYS use `context.t` - NEVER hardcode strings:**

```dart
// ✅ Correct
Text(context.t.authWelcomeBack)
Text(context.t.walletBalance)

// ❌ Wrong
Text('Welcome Back')  // Hardcoded
Text('Balance')  // Hardcoded
```

## MVI Single Entry Point

**ALWAYS use `bloc.onAction()` - NEVER add events directly:**

```dart
// ✅ Correct
_bloc.onAction(const LoadWalletAction());
_bloc.onAction(RefreshDataAction(id: walletId));

// ❌ Wrong
_bloc.add(LoadWalletEvent());  // Direct event access forbidden
```

## File Naming

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` (not SCREAMING_SNAKE_CASE)
- **Booleans**: Start with `is`, `has`, `can`

```dart
// ✅ Correct
class WalletBloc { }
final walletRepository = WalletRepository();
const walletTimeout = Duration(seconds: 30);
bool isLoading = false;
bool hasError = false;

// ❌ Wrong
class wallet_bloc { }
final WalletRepository = WalletRepository();
const WALLET_TIMEOUT = Duration(seconds: 30);
bool loading = false;  // Missing 'is' prefix
```

## Code Generation

**ALWAYS run before committing:**

```bash
melos genAlls                    # Generate all code
dart format lib/                 # Format code
flutter analyze --no-fatal-infos  # Must show "No issues found!"
```

## Error Handling

**Use `SafeCallApiMixin` for API calls:**

```dart
class WalletRemoteDataSource with SafeCallApiMixin {
  Future<WalletModel> getWallet(String id) async {
    return safeCallApi(() => _apiClient.getWallet(id));
  }
}
```

## Summary

| Convention | Rule | Example |
|------------|------|---------|
| **Imports** | Full package paths only | `import 'package:bloc_digital_wallet/...'` |
| **Freezed** | `@freezed` + `abstract class` + `@JsonKey` | See examples above |
| **Files** | One object per file | `wallet_entity.dart` |
| **Retrofit** | Explicit baseUrl | `@RestApi(baseUrl: '...')` |
| **Enums** | Dot shorthands | `.contain`, `.srcIn` |
| **Theme** | `context.appThemes` | Never hardcode colors |
| **i18n** | `context.t` | Never hardcode strings |
| **MVI** | `bloc.onAction()` | Never `bloc.add()` |
| **Naming** | snake_case files, PascalCase classes | `wallet_bloc.dart`, `WalletBloc` |
| **Generation** | Run before commit | `melos genAlls` |

---

**Last Updated**: 2026-01-22  
**Status**: Active ✅
