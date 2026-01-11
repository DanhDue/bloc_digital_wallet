# MVI Feature Brick

Generate a complete feature following **Clean Architecture + MVI** pattern.

## 🎯 What It Generates

### Complete feature structure with:
- ✅ Domain layer (entities, repositories, use cases)
- ✅ Data layer (models with Freezed, data sources, repository impl)
- ✅ Presentation layer (MVI: intents, states, side effects, BLoC, pages)
- ✅ Dependency injection ready
- ✅ Error handling with Either
- ✅ Immutable models with Freezed
- ✅ Local caching strategy
- ✅ Side effects for one-time events

## 🚀 Usage

```bash
mason make mvi_feature --feature_name wallet
```

## 📁 Generated Structure

```
lib/features/wallet/
├── data/
│   ├── datasources/
│   │   ├── wallet_remote_datasource.dart
│   │   └── wallet_local_datasource.dart
│   ├── models/
│   │   └── wallet_model.dart
│   └── repositories/
│       └── wallet_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── wallet_entity.dart
│   ├── repositories/
│   │   └── wallet_repository.dart
│   └── usecases/
│       ├── get_wallet_usecase.dart
│       └── get_all_wallets_usecase.dart
└── presentation/
    ├── mvi/
    │   ├── wallet_intent.dart
    │   ├── wallet_state.dart
    │   ├── wallet_side_effect.dart
    │   └── wallet_bloc.dart
    └── pages/
        └── wallet_page.dart
```

## 🔧 After Generation

1. **Update entity properties**:
   ```dart
   // wallet_entity.dart
   class WalletEntity extends Equatable {
     final String address;
     final double balance;
     final String network;
     // Add your properties
   }
   ```

2. **Update model properties**:
   ```dart
   // wallet_model.dart
   @freezed
   class WalletModel with _$WalletModel {
     const factory WalletModel({
       required String address,
       required double balance,
       required String network,
     }) = _WalletModel;
   }
   ```

3. **Implement data sources**:
   ```dart
   // wallet_remote_datasource.dart
   class WalletRemoteDataSourceImpl {
     final Dio dio;
     
     @override
     Future<WalletModel> getWallet(String address) async {
       final response = await dio.get('/wallets/$address');
       return WalletModel.fromJson(response.data);
     }
   }
   ```

4. **Run code generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Register in DI**:
   ```dart
   @module
   abstract class WalletModule {
     @lazySingleton
     WalletRemoteDataSource remoteDataSource(Dio dio) =>
         WalletRemoteDataSourceImpl(dio);
     
     // ... register other dependencies
   }
   ```

6. **Use in your app**:
   ```dart
   BlocProvider(
     create: (_) => getIt<WalletBloc>()
       ..add(LoadWalletIntent('address')),
     child: WalletPage(),
   )
   ```

## 🎨 MVI Pattern

### Intent → BLoC → State + Side Effects → View

**Intent** (User action):
```dart
class LoadWalletIntent extends WalletIntent {
  final String address;
}
```

**State** (UI state):
```dart
class WalletLoaded extends WalletState {
  final WalletEntity wallet;
}
```

**Side Effect** (One-time event):
```dart
class ShowSuccessMessage extends WalletSideEffect {
  final String message;
}
```

**BLoC** (Business logic):
```dart
class WalletBloc extends MviBloc<
  WalletIntent, 
  WalletState, 
  WalletSideEffect
> {
  // Transforms intents to states
  // Emits side effects
}
```

**View** (UI):
```dart
BlocBuilder<WalletBloc, WalletState>(
  builder: (context, state) {
    return switch (state) {
      WalletLoading() => CircularProgressIndicator(),
      WalletLoaded(:final wallet) => WalletView(wallet),
      WalletError(:final message) => ErrorView(message),
    };
  },
)
```

## 📚 Clean Architecture Layers

### Domain Layer
- **Entities**: Business objects (pure Dart)
- **Repositories**: Abstract interfaces
- **Use Cases**: Single-responsibility operations

### Data Layer
- **Models**: DTOs with JSON serialization
- **Data Sources**: Remote (API) and Local (Cache)
- **Repositories**: Concrete implementations

### Presentation Layer (MVI)
- **Intents**: User actions
- **States**: UI states
- **Side Effects**: One-time events
- **BLoC**: Business logic
- **Pages**: UI widgets

## ✅ Best Practices

1. **Keep entities simple** - No framework dependencies
2. **Use Either for errors** - Left(Failure) or Right(Success)
3. **Cache strategically** - Try cache first, then remote
4. **Separate side effects** - Don't mix with state
5. **Use sealed classes** - For exhaustive pattern matching
6. **One use case, one responsibility** - Don't create god use cases

## 🧪 Testing

```dart
// Use case test
test('should return wallet when repository succeeds', () async {
  when(() => repository.getWallet(any()))
      .thenAnswer((_) async => Right(tWallet));
  
  final result = await useCase('address');
  
  expect(result, Right(tWallet));
});

// BLoC test
blocTest<WalletBloc, WalletState>(
  'emits [Loading, Loaded] when LoadWalletIntent succeeds',
  build: () => WalletBloc(getWalletUseCase: mockUseCase),
  act: (bloc) => bloc.add(LoadWalletIntent('address')),
  expect: () => [
    WalletLoading(),
    WalletLoaded(tWallet),
  ],
);
```

## 📖 Learn More

- [Clean Architecture](../docs/ARCHITECTURE.md)
- [MVI Pattern](../docs/VISUAL_GUIDE.md)
- [Project README](../../README.md)

---

**Happy Coding! 🚀**
