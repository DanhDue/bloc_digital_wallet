# Flutter Quality Rules — Consolidated Cheat Sheet

> **Authoritative source for quality audit skills:**
> `d3nexus:flutter-ui-audit` · `d3nexus:architecture-audit` ·
> `d3nexus:code-health-audit` · `d3nexus:security-audit`
>
> _Extracted from: `QUICK_REFERENCE.md`, `ARCHITECTURE.md`, `THEME_TAILOR_GUIDE.md`,
> `SLANG_LOCALIZATION_GUIDE.md`, `NETWORKING.md`, `REFRESH_TOKEN_DESIGN.md`_

---

## 1. MVI Naming Conventions

### Actions — `Verb + Noun + Action`
| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `WalletLoad` | `LoadWalletAction` |
| `bloc.add(event)` directly | `bloc.onAction(action)` |
| `CreateTx` | `CreateTransactionAction` |

### States — `Noun + State/Adjective`
| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `Loading` (ambiguous) | `WalletLoading` |
| `WalletData` | `WalletLoaded` |
| Using State for one-time navigation | Use `WalletEvent` instead |

### Events — `Verb + Noun` or `Show/Navigate + What`
| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `WalletNavigate` | `NavigateToHome` |
| State with `isSuccess: bool` | `ShowSuccessMessage` event |

### Files — snake_case always
```
wallet_entity.dart        ✅
walletEntity.dart         ❌
WalletEntity.dart         ❌
```

---

## 2. Architecture Layer Rules

### Dependency Direction
```
View → BLoC → UseCase → Repository → DataSource
         ↑_____________________________|
         Data layer implements domain interfaces
```

| Rule | ❌ Wrong | ✅ Correct |
|------|---------|-----------|
| **Pure Domain** | `import 'package:flutter/...'` in UseCase/Entity | Pure Dart only — no Flutter imports |
| **Dependency Rule** | Data layer depends on Presentation | Presentation → Domain ← Data |
| **Single Entry Point** | `bloc.add(action)` called from View | `bloc.onAction(action)` only |
| **State vs Event** | State with `isNavigate: bool` | State = persistent UI data, Event = one-time side effect |
| **Entity purity** | Entity annotated with `@JsonKey` | Model (`@freezed`) handles JSON; Entity is pure |
| **Business logic location** | Logic inside Widget `build()` | Logic in UseCase, BLoC maps to state |

### Layer-Specific Injectable Annotations
```dart
// Domain
@injectable class GetWalletUseCase { }

// Data
@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository { }

// ❌ WRONG — using @singleton in feature logic
@singleton class WalletBloc { }  // BLoC must be @injectable (scoped)
```

---

## 3. Common Anti-Patterns

| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `bloc.add(action)` directly | `bloc.onAction(action)` |
| Flutter imports in Domain | Pure Dart only |
| Multiple BLoC entry points | Single `onAction()` |
| Business logic in Widget `build()` | Logic in UseCase |
| Using State for navigation/toasts | Use Events for one-time effects |
| Entity with `@JsonKey` annotation | Model with `@freezed` + `.toEntity()` |
| `getIt<X>()` inside widget tree ad-hoc | Inject via `BlocProvider.create` |
| Barrel export of everything | Only export public API from feature |
| Cross-feature imports via relative paths | Import via package name only |

---

## 4. Theme Usage Rules

### ❌ NEVER — Raw Flutter theme / hardcoded colors
```dart
// ❌ NEVER use these
Theme.of(context).textTheme.bodyMedium
Theme.of(context).colorScheme.surface
Colors.red
Color(0xFF123456)  // Hardcoded hex
```

### ✅ ALWAYS — ThemeTailor design tokens
```dart
// ✅ Text styles
context.appThemes.headlineSmall
context.appThemes.bodyMedium
context.appThemes.labelLarge

// ✅ Colors
context.appThemes.primaryColor
context.appThemes.surfaceColor
context.appThemes.errorColor
context.appThemes.textSecondaryColor

// ✅ Combined
context.appThemes.bodyMedium.copyWith(
  color: context.appThemes.textSecondaryColor,
)
```

### Widget Rebuild Rule
```dart
// ❌ WRONG — causes unnecessary rebuilds
Widget build(BuildContext context) {
  final theme = Theme.of(context);  // rebuilds on any theme change
}

// ✅ CORRECT — access only what you need
Widget build(BuildContext context) {
  final color = context.appThemes.primaryColor;  // ThemeTailor extension
}
```

---

## 5. Localization Rules

### ❌ NEVER — Hardcoded strings
```dart
// ❌ NEVER hardcode user-facing strings
Text('Welcome back')
Text('Error: $message')
SnackBar(content: Text('Success!'))
```

### ✅ ALWAYS — Slang type-safe keys
```dart
// ✅ Core package strings (shared across features)
context.coreT.welcomeBack
context.coreT.errorMessage(message: message)

// ✅ Feature-specific strings
context.t.walletLoaded
context.t.transactionSuccess
```

### Plural / Parameter Rules
```dart
// ❌ WRONG — string concatenation
Text('${count} items found')

// ✅ CORRECT — Slang pluralization
context.t.itemsFound(n: count)
```

### Adding New Translations
```
// ❌ Add to random .json files
features/wallet/assets/i18n/strings_en.json  ← wrong location

// ✅ Add to the correct package i18n folder
packages/core/assets/i18n/en.json    ← shared strings
features/wallet/assets/i18n/en.json  ← feature strings
// Then run: melos genAlls
```

---

## 6. Networking Rules

### ❌ NEVER — Decentralized base URL / direct Dio usage
```dart
// ❌ WRONG — URI construction scattered in feature
final uri = Uri.parse('https://api.example.com/v1/wallet/$id');
final response = await http.get(uri);

// ❌ WRONG — Dio created ad-hoc in DataSource
final dio = Dio(BaseOptions(baseUrl: 'https://...'));
```

### ✅ ALWAYS — Centralized NetworkModule + Retrofit
```dart
// ✅ CORRECT — Retrofit interface in feature
@RestApi()
abstract class WalletApi {
  @GET('/wallet/{id}')
  Future<WalletModel> getWallet(@Path('id') String id);
}

// ✅ CORRECT — Dio injected from NetworkModule (registered in host)
@injectable
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final WalletApi _api;
  WalletRemoteDataSourceImpl(this._api);
}
```

### Error Handling — Always Propagate as `Failure`
```dart
// ❌ WRONG — swallowing exceptions
try {
  return await api.getWallet(id);
} catch (e) {
  return null;
}

// ✅ CORRECT — wrap in Either
Future<Either<Failure, WalletEntity>> getWallet(String id) async {
  try {
    final model = await _api.getWallet(id);
    return Right(model.toEntity());
  } on DioException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}
```

---

## 7. Token Security Rules

### ❌ NEVER — Insecure token storage
```dart
// ❌ NEVER store tokens in SharedPreferences (plaintext)
final prefs = await SharedPreferences.getInstance();
prefs.setString('access_token', token);

// ❌ NEVER store tokens in Hive without encryption
Box<String> tokenBox = Hive.box('tokens');
tokenBox.put('access_token', token);

// ❌ NEVER log tokens
logger.d('Token: $accessToken');
```

### ✅ ALWAYS — Secure platform storage
```dart
// ✅ Use flutter_secure_storage (Keychain on iOS, Keystore on Android)
final storage = FlutterSecureStorage();
await storage.write(key: 'access_token', value: token);
final token = await storage.read(key: 'access_token');

// ✅ Never log sensitive data
logger.d('Token refreshed successfully');  // log event, not value
```

### Token Refresh — Mutex Lock Required
```dart
// ❌ WRONG — race condition on concurrent refresh
Future<String> getAccessToken() async {
  if (_isExpired) return await _refresh();  // multiple calls trigger multiple refreshes
}

// ✅ CORRECT — Mutex prevents concurrent refresh
final _mutex = Mutex();
Future<String> getAccessToken() async {
  return _mutex.protect(() async {
    if (_isExpired) await _refresh();
    return _cachedToken!;
  });
}
```

---

## 8. Dependency Injection Rules

### Registration Rules
| Layer | Annotation | Scope |
|-------|-----------|-------|
| UseCase | `@injectable` | Per-request (factory) |
| Repository impl | `@LazySingleton(as: IRepository)` | App-wide singleton |
| DataSource impl | `@LazySingleton(as: IDataSource)` | App-wide singleton |
| BLoC | `@injectable` | Scoped (never singleton) |
| API (Retrofit) | `@lazySingleton` | App-wide singleton |

### ❌ Wrong DI Patterns
```dart
// ❌ WRONG — BLoC as singleton (state leaks between sessions)
@singleton
class WalletBloc extends MviBloc { }

// ❌ WRONG — direct GetIt call inside domain layer
class GetWalletUseCase {
  GetWalletUseCase() : _repo = getIt<WalletRepository>();  // breaks testability
}

// ❌ WRONG — registering in feature instead of host
// Features must NOT call GetIt.instance.registerSingleton()
// Only the host app's AppModule registers singletons
```

### ✅ Correct DI Pattern
```dart
// ✅ Constructor injection everywhere
@injectable
class GetWalletUseCase {
  final WalletRepository _repository;
  GetWalletUseCase(this._repository);  // injectable_generator handles this
}

// ✅ BLoC provided via BlocProvider in Presentation
BlocProvider(
  create: (_) => getIt<WalletBloc>()..onAction(LoadWalletAction(id)),
  child: WalletPage(),
)
```
