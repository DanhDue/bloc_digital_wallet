# Clean Architecture Pattern Guide

**Quick reference for Clean Architecture layers**

---

## 🏗️ Layer Structure

```
lib/features/{feature}/
├── domain/              # Pure Dart, no Flutter
│   ├── entities/
│   ├── repositories/    # Interfaces (abstract classes)
│   └── usecases/
├── data/                # Implementation
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presentation/        # Flutter UI + MVI
    ├── mvi/
    ├── pages/
    └── widgets/
```

---

## 📊 Dependency Rule

```
Presentation → Domain ← Data
```

**Key Rules**:
- Domain knows nothing about outer layers
- Presentation depends on Domain
- Data depends on Domain (implements Domain interfaces)
- NO imports from outer to inner layers

---

## 🎯 Domain Layer (Pure Dart)

### Entity

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'wallet_entity.freezed.dart';
part 'wallet_entity.g.dart';

@freezed
abstract class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'balance') double? balance,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, Object?> json) =>
      _$WalletEntityFromJson(json);
}
```

**Rules**:
- Uses `@freezed` with `abstract class` and `_$ClassName` mixin
- Uses `@JsonKey(name: 'field_name')` for explicit JSON mapping
- Imports `foundation.dart` for Flutter compatibility
- Contains `fromJson` factory for JSON deserialization

⚠️ **IMPORTANT**: All entities and models will use freezed with `@JsonKey` annotations.

---

### Repository Interface

```dart
abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet(String id);
  Future<Either<Failure, List<WalletEntity>>> getTransactions(String walletId);
}
```

**Rules**:
- Abstract class or interface
- Returns `Either<Failure, Success>`
- No implementation details

---

### Use Case

```dart
@injectable
class GetWalletUseCase {
  final WalletRepository _repository;
  
  const GetWalletUseCase(this._repository);
  
  Future<Either<Failure, WalletEntity>> call(String id) async {
    // Business validation
    if (id.isEmpty) {
      return const Left(ValidationFailure('Wallet ID is required'));
    }
    
    // Call repository
    return _repository.getWallet(id);
  }
}
```

**Rules**:
- Single responsibility
- Business validation
- Calls repository interface
- Returns `Either<Failure, Success>`
- Annotated with `@injectable`

---

## 💾 Data Layer (Implementation)

### Model (DTO)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const WalletModel._();
  
  const factory WalletModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'balance') double? balance,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, Object?> json) =>
      _$WalletModelFromJson(json);
  
  // Convert to Entity
  WalletEntity toEntity() => WalletEntity(
    id: id,
    balance: balance,
  );
  
  // Convert from Entity
  factory WalletModel.fromEntity(WalletEntity entity) => WalletModel(
    id: entity.id,
    balance: entity.balance,
  );
}
```

**Rules**:
- Uses `@freezed` with `abstract class` and `_$ClassName` mixin
- Uses `@JsonKey(name: 'field_name')` for explicit JSON mapping
- Imports `foundation.dart` for Flutter compatibility
- Has `fromJson` for API responses with `Map<String, Object?>`
- Has `toEntity()` and `fromEntity()` for conversion

⚠️ **IMPORTANT**: All entities and models will use freezed with `@JsonKey` annotations.

---

### Data Source

```dart
abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet(String id);
}

@LazySingleton(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio _dio;
  
  const WalletRemoteDataSourceImpl(this._dio);
  
  @override
  Future<WalletModel> getWallet(String id) async {
    try {
      final response = await _dio.get('/wallets/$id');
      return WalletModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
```

**Rules**:
- Throws Exceptions (NOT Failures)
- Handles Dio/HTTP errors
- Returns Models (DTOs)

---

### Repository Implementation

```dart
@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;
  
  const WalletRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Either<Failure, WalletEntity>> getWallet(String id) async {
    try {
      final model = await _remoteDataSource.getWallet(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error: $e'));
    }
  }
}
```

**Rules**:
- Implements Domain repository interface
- Converts Exceptions → Failures
- Converts Models → Entities
- Returns `Either<Failure, Success>`
- Annotated with `@LazySingleton(as: Interface)`

---

## 🎨 Presentation Layer (MVI + Flutter)

See `patterns/mvi-patterns.md` for MVI implementation.

**Key Points**:
- Uses Flutter widgets
- Depends on Domain layer (UseCases)
- Implements MVI pattern (Action/State/Event/BLoC)

---

## 🔄 Data Flow Example

```
1. User taps button
   ↓
2. Widget dispatches Action
   _bloc.onAction(const LoadWalletAction('123'))
   ↓
3. BLoC receives Action
   onAction(LoadWalletAction(:final id))
   ↓
4. BLoC calls UseCase
   await _getWalletUseCase(id)
   ↓
5. UseCase calls Repository (interface)
   _repository.getWallet(id)
   ↓
6. Repository Impl calls DataSource
   _remoteDataSource.getWallet(id)
   ↓
7. DataSource makes API call
   _dio.get('/wallets/$id')
   ↓
8. Response flows back up:
   Model → Entity → UseCase → BLoC → State/Event
   ↓
9. Widget rebuilds based on State
   BlocBuilder<WalletBloc, WalletState>(...)
```

---

## ⚠️ Common Mistakes

### ❌ Wrong Patterns

```dart
// 1. Flutter imports in Domain
import 'package:flutter/material.dart';  // ❌ In domain layer

// 2. Domain depends on Data
import '../data/models/wallet_model.dart';  // ❌ In domain

// 3. DataSource returns Failure
return Left(ServerFailure('Error'));  // ❌ Should throw Exception

// 4. Repository throws Exception
throw ServerException('Error');  // ❌ Should return Either<Failure, Success>

// 5. BLoC directly calls DataSource
_remoteDataSource.getWallet(id);  // ❌ Should use UseCase
```

### ✅ Correct Patterns

```dart
// 1. Pure Dart in Domain
// No Flutter imports  // ✅

// 2. Data depends on Domain
import '../../domain/entities/wallet_entity.dart';  // ✅

// 3. DataSource throws Exception
throw ServerException('Error');  // ✅

// 4. Repository returns Either
return Left(ServerFailure('Error'));  // ✅

// 5. BLoC uses UseCase
await _getWalletUseCase(id);  // ✅
```

---

## 📚 Key Principles

1. **Dependency Rule**: Outer depends on inner, never reverse
2. **Pure Domain**: No framework dependencies in Domain layer
3. **Interface Segregation**: Domain defines interfaces, Data implements
4. **Exception Handling**: DataSource throws, Repository converts to Failure
5. **Entity Conversion**: Models convert to/from Entities

---

**Source**: `docs/architecture/ARCHITECTURE.md`, `docs/development/IMPLEMENTATION_GUIDE.md`
