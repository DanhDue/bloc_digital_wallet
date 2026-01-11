# Quick Start: Creating a Feature with Mason

This guide will walk you through creating a new feature using Mason in under 5 minutes.

## 🚀 Quick Example: Create a "Transaction" Feature

### Step 1: Generate the Feature

```bash
cd /path/to/bloc_digital_wallet
mason make clean_feature --feature_name transaction
```

You'll be prompted:
```
✓ What is the feature name? (e.g., authentication, wallet, transaction) · transaction
✓ Use Equatable for value equality? (Y/n) · yes
✓ Generate use case examples? (Y/n) · yes  
✓ Generate repository and data source? (Y/n) · yes
✓ Use Freezed for data classes? (Y/n) · yes
✓ Generate test files? (Y/n) · yes
```

### Step 2: Run Code Generation

```bash
melos build_runner
```

This generates:
- Freezed models (`.freezed.dart`)
- JSON serialization (`.g.dart`)
- Injectable DI (`.config.dart`)

### Step 3: Customize Your Feature

#### 3.1 Update Entity (`lib/features/transaction/domain/entities/transaction_entity.dart`)

```dart
class TransactionEntity extends Equatable {
  final String id;
  final String fromAddress;
  final String toAddress;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final TransactionStatus status;

  const TransactionEntity({
    required this.id,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        fromAddress,
        toAddress,
        amount,
        currency,
        timestamp,
        status,
      ];
}

enum TransactionStatus { pending, completed, failed }
```

#### 3.2 Update Model (`lib/features/transaction/data/models/transaction_model.dart`)

```dart
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String fromAddress,
    required String toAddress,
    required double amount,
    required String currency,
    required DateTime timestamp,
    required String status,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionModelX on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      currency: currency,
      timestamp: timestamp,
      status: _parseStatus(status),
    );
  }

  TransactionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}
```

#### 3.3 Implement Remote Data Source

```dart
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl(this.dio);

  @override
  Future<TransactionModel> getTransaction(String id) async {
    final response = await dio.get('/transactions/$id');
    return TransactionModel.fromJson(response.data);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final response = await dio.get('/transactions');
    return (response.data as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) async {
    final response = await dio.post('/transactions', data: model.toJson());
    return TransactionModel.fromJson(response.data);
  }

  // ... implement other methods
}
```

### Step 4: Register in Dependency Injection

Edit `lib/di/injection.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

// Add this module
@module
abstract class TransactionModule {
  @lazySingleton
  TransactionRemoteDataSource remoteDataSource(Dio dio) =>
      TransactionRemoteDataSourceImpl(dio);

  @lazySingleton
  TransactionLocalDataSource localDataSource() =>
      TransactionLocalDataSourceImpl();

  @lazySingleton
  TransactionRepository repository(
    TransactionRemoteDataSource remoteDataSource,
    TransactionLocalDataSource localDataSource,
  ) =>
      TransactionRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );

  @lazySingleton
  GetTransactionUseCase getTransactionUseCase(TransactionRepository repository) =>
      GetTransactionUseCase(repository);

  @lazySingleton
  GetAllTransactionsUseCase getAllTransactionsUseCase(
          TransactionRepository repository) =>
      GetAllTransactionsUseCase(repository);
}
```

Then regenerate:
```bash
melos build_runner
```

### Step 5: Add Routing

If using AutoRoute, add to your router:

```dart
@MaterialRoute(page: TransactionPage)
```

### Step 6: Use in Your App

```dart
// In your navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => getIt<TransactionBloc>()
        ..add(const GetAllTransactionsEvent()),
      child: const TransactionPage(),
    ),
  ),
);
```

### Step 7: Format and Add License Headers

```bash
melos dartfmt
melos add-license-header
```

## ✅ Done!

You now have a complete feature with:
- ✅ Clean Architecture structure
- ✅ BLoC for state management
- ✅ Repository pattern with caching
- ✅ Type-safe models with Freezed
- ✅ Dependency injection
- ✅ Error handling with Either
- ✅ UI with loading/error states

## 🎯 Next Steps

1. **Add API Integration**: Connect to your actual blockchain API
2. **Add Tests**: Write unit tests for use cases, BLoC, and repository
3. **Enhance UI**: Customize the page and widgets
4. **Add Navigation**: Integrate with your routing solution

## 📊 What You Get Out of the Box

### Domain Layer
- `transaction_entity.dart` - Business object
- `transaction_repository.dart` - Repository interface
- `get_transaction_usecase.dart` - Get single transaction
- `get_all_transactions_usecase.dart` - Get all transactions

### Data Layer
- `transaction_model.dart` - Data model with JSON serialization
- `transaction_remote_data_source.dart` - API integration
- `transaction_local_data_source.dart` - Local caching
- `transaction_repository_impl.dart` - Repository implementation

### Presentation Layer
- `transaction_bloc.dart` - BLoC for state management
- `transaction_event.dart` - User actions
- `transaction_state.dart` - UI states
- `transaction_page.dart` - Main page
- `transaction_list_widget.dart` - List widget

## 🔄 Typical Development Workflow

```bash
# 1. Generate feature
mason make clean_feature --feature_name payment

# 2. Run code generation
melos build_runner

# 3. Implement business logic
# - Update entity properties
# - Update model properties
# - Implement data sources
# - Add use cases if needed

# 4. Register in DI
# - Edit lib/di/injection.dart

# 5. Regenerate
melos build_runner

# 6. Format & license
melos dartfmt
melos add-license-header

# 7. Test
melos test

# 8. Commit
git add .
git commit -m "feat: add payment feature"
```

## 💡 Pro Tips

1. **Keep entities simple**: Only business properties, no framework dependencies
2. **Use value objects**: For complex types like `Money`, `Address`, etc.
3. **One use case, one responsibility**: Don't create god use cases
4. **Cache strategically**: Not everything needs caching
5. **Test first**: Write tests for domain layer before implementing data layer

## 🐛 Common Issues

### Issue: "Cannot find import"
**Solution**: Run `melos build_runner` to generate missing files

### Issue: "DI not working"
**Solution**: Make sure you registered the module and ran `melos build_runner`

### Issue: "Type mismatch in Either"
**Solution**: Check your Failure types match between layers

## 📚 Learn More

- [Full Mason Guide](MASON_GUIDE.md)
- [Clean Architecture Principles](MASON_GUIDE.md#clean-architecture-structure)
- [BLoC Best Practices](https://bloclibrary.dev)

---

**Happy Coding! 🚀**
