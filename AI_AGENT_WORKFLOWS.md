# AI Agent Workflows

**Companion to AI_AGENT_CONTEXT.md**

This document provides step-by-step workflows for common tasks AI Agents will perform.

---

## 📋 Table of Contents

1. [Workflow: Create Complete New Feature](#workflow-create-complete-new-feature)
2. [Workflow: Add New API Endpoint Integration](#workflow-add-new-api-endpoint-integration)
3. [Workflow: Fix Bug in Existing Feature](#workflow-fix-bug-in-existing-feature)
4. [Workflow: Add New Use Case to Existing Feature](#workflow-add-new-use-case-to-existing-feature)
5. [Workflow: Update Entity/Model](#workflow-update-entitymodel)
6. [Workflow: Handle Dependency Conflicts](#workflow-handle-dependency-conflicts)
7. [Workflow: Debug State Management Issues](#workflow-debug-state-management-issues)
8. [Workflow: Add Unit Tests](#workflow-add-unit-tests)
9. [Workflow: Refactor Existing Code](#workflow-refactor-existing-code)
10. [Workflow: Performance Optimization](#workflow-performance-optimization)

---

## Workflow: Create Complete New Feature

**Scenario**: User requests a new feature (e.g., "Add transaction history feature")

### Step 1: Extract Feature Name
```
User Input: "Add transaction history feature"
Extract: feature_name = "transaction_history" (snake_case)
```

### Step 2: Generate Feature Structure
```bash
cd /Users/danhdue/AllProjects/sample/bloc_digital_wallet
mason make mvi_feature --feature_name transaction_history
```

**Expected Output**: Files generated in `lib/features/transaction_history/`

### Step 3: Define Domain Layer

#### 3.1 Update Entity
**File**: `lib/features/transaction_history/domain/entities/transaction_history_entity.dart`

```dart
import 'package:equatable/equatable.dart';

class TransactionHistoryEntity extends Equatable {
  final String id;
  final String transactionId;
  final String type; // 'send', 'receive', 'swap'
  final double amount;
  final String currency;
  final DateTime timestamp;
  final TransactionStatus status;

  const TransactionHistoryEntity({
    required this.id,
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        transactionId,
        type,
        amount,
        currency,
        timestamp,
        status,
      ];
}

enum TransactionStatus { pending, completed, failed }
```

#### 3.2 Define Repository Interface
**File**: `lib/features/transaction_history/domain/repositories/transaction_history_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_history_entity.dart';

abstract class TransactionHistoryRepository {
  Future<Either<Failure, List<TransactionHistoryEntity>>> getTransactionHistory({
    required String walletAddress,
    int? limit,
    int? offset,
  });
  
  Future<Either<Failure, TransactionHistoryEntity>> getTransactionById(String id);
}
```

#### 3.3 Create Use Cases
**File**: `lib/features/transaction_history/domain/usecases/get_transaction_history_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_history_entity.dart';
import '../repositories/transaction_history_repository.dart';

@injectable
class GetTransactionHistoryUseCase {
  final TransactionHistoryRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  Future<Either<Failure, List<TransactionHistoryEntity>>> call({
    required String walletAddress,
    int? limit,
    int? offset,
  }) async {
    // Business logic validation
    if (walletAddress.isEmpty) {
      return Left(ValidationFailure(message: 'Wallet address is required'));
    }

    return await repository.getTransactionHistory(
      walletAddress: walletAddress,
      limit: limit,
      offset: offset,
    );
  }
}
```

### Step 4: Implement Data Layer

#### 4.1 Create Model
**File**: `lib/features/transaction_history/data/models/transaction_history_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction_history_entity.dart';

part 'transaction_history_model.freezed.dart';
part 'transaction_history_model.g.dart';

@freezed
class TransactionHistoryModel with _$TransactionHistoryModel {
  const TransactionHistoryModel._();

  const factory TransactionHistoryModel({
    required String id,
    required String transactionId,
    required String type,
    required double amount,
    required String currency,
    required String timestamp,
    required String status,
  }) = _TransactionHistoryModel;

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryModelFromJson(json);

  TransactionHistoryEntity toEntity() {
    return TransactionHistoryEntity(
      id: id,
      transactionId: transactionId,
      type: type,
      amount: amount,
      currency: currency,
      timestamp: DateTime.parse(timestamp),
      status: _parseStatus(status),
    );
  }

  factory TransactionHistoryModel.fromEntity(TransactionHistoryEntity entity) {
    return TransactionHistoryModel(
      id: entity.id,
      transactionId: entity.transactionId,
      type: entity.type,
      amount: entity.amount,
      currency: entity.currency,
      timestamp: entity.timestamp.toIso8601String(),
      status: entity.status.name,
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

#### 4.2 Implement Remote Data Source
**File**: `lib/features/transaction_history/data/datasources/transaction_history_remote_datasource.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_history_model.dart';

abstract class TransactionHistoryRemoteDataSource {
  Future<List<TransactionHistoryModel>> getTransactionHistory({
    required String walletAddress,
    int? limit,
    int? offset,
  });
}

@LazySingleton(as: TransactionHistoryRemoteDataSource)
class TransactionHistoryRemoteDataSourceImpl
    implements TransactionHistoryRemoteDataSource {
  final Dio dio;

  const TransactionHistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TransactionHistoryModel>> getTransactionHistory({
    required String walletAddress,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await dio.get(
        '/transactions/history',
        queryParameters: {
          'wallet_address': walletAddress,
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['transactions'];
        return data
            .map((json) => TransactionHistoryModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to get transaction history',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        originalException: e,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

#### 4.3 Implement Repository
**File**: `lib/features/transaction_history/data/repositories/transaction_history_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_history_entity.dart';
import '../../domain/repositories/transaction_history_repository.dart';
import '../datasources/transaction_history_remote_datasource.dart';

@LazySingleton(as: TransactionHistoryRepository)
class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {
  final TransactionHistoryRemoteDataSource remoteDataSource;

  TransactionHistoryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<TransactionHistoryEntity>>> getTransactionHistory({
    required String walletAddress,
    int? limit,
    int? offset,
  }) async {
    try {
      final remoteData = await remoteDataSource.getTransactionHistory(
        walletAddress: walletAddress,
        limit: limit,
        offset: offset,
      );
      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionHistoryEntity>> getTransactionById(
      String id) async {
    // Implementation here
    throw UnimplementedError();
  }
}
```

### Step 5: Implement Presentation Layer

#### 5.1 Define Actions
**File**: `lib/features/transaction_history/presentation/mvi/transaction_history_action.dart`

```dart
import '../../../../core/architecture/architecture.dart';

sealed class TransactionHistoryAction extends BaseAction {
  const TransactionHistoryAction();
}

class LoadTransactionHistoryAction extends TransactionHistoryAction {
  final String walletAddress;
  const LoadTransactionHistoryAction(this.walletAddress);
}

class RefreshTransactionHistoryAction extends TransactionHistoryAction {
  final String walletAddress;
  const RefreshTransactionHistoryAction(this.walletAddress);
}

class LoadMoreTransactionsAction extends TransactionHistoryAction {
  final String walletAddress;
  const LoadMoreTransactionsAction(this.walletAddress);
}
```

#### 5.2 Define States
**File**: `lib/features/transaction_history/presentation/mvi/transaction_history_state.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/transaction_history_entity.dart';

sealed class TransactionHistoryState extends BaseState with EquatableMixin {
  const TransactionHistoryState();
}

class TransactionHistoryInitial extends TransactionHistoryState {
  const TransactionHistoryInitial();
  @override
  List<Object?> get props => [];
}

class TransactionHistoryLoading extends TransactionHistoryState {
  const TransactionHistoryLoading();
  @override
  List<Object?> get props => [];
}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<TransactionHistoryEntity> transactions;
  final bool hasMore;

  const TransactionHistoryLoaded({
    required this.transactions,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [transactions, hasMore];
}

class TransactionHistoryLoadingMore extends TransactionHistoryState {
  final List<TransactionHistoryEntity> currentTransactions;

  const TransactionHistoryLoadingMore(this.currentTransactions);

  @override
  List<Object?> get props => [currentTransactions];
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;
  const TransactionHistoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class TransactionHistoryEmpty extends TransactionHistoryState {
  const TransactionHistoryEmpty();
  @override
  List<Object?> get props => [];
}
```

#### 5.3 Define Events
**File**: `lib/features/transaction_history/presentation/mvi/transaction_history_event.dart`

```dart
import '../../../../core/architecture/architecture.dart';

sealed class TransactionHistoryEvent extends BaseEvent {
  const TransactionHistoryEvent();
}

class ShowSuccessMessage extends TransactionHistoryEvent {
  final String message;
  const ShowSuccessMessage(this.message);
}

class ShowErrorMessage extends TransactionHistoryEvent {
  final String message;
  const ShowErrorMessage(this.message);
}

class NavigateToTransactionDetail extends TransactionHistoryEvent {
  final String transactionId;
  const NavigateToTransactionDetail(this.transactionId);
}
```

#### 5.4 Implement BLoC
**File**: `lib/features/transaction_history/presentation/mvi/transaction_history_bloc.dart`

```dart
import 'package:injectable/injectable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_action.dart';
import 'transaction_history_state.dart';
import 'transaction_history_event.dart';

@injectable
class TransactionHistoryBloc extends MviBloc<TransactionHistoryAction,
    TransactionHistoryState, TransactionHistoryEvent> {
  final GetTransactionHistoryUseCase getTransactionHistoryUseCase;

  static const int _pageSize = 20;
  int _currentOffset = 0;

  TransactionHistoryBloc({
    required this.getTransactionHistoryUseCase,
  }) : super(const TransactionHistoryInitial());

  @override
  Future<void> onAction(
    TransactionHistoryAction action,
    Emitter<TransactionHistoryState> emit,
  ) async {
    switch (action) {
      case LoadTransactionHistoryAction(:final walletAddress):
        await _loadTransactionHistory(walletAddress, emit);
      case RefreshTransactionHistoryAction(:final walletAddress):
        _currentOffset = 0;
        await _loadTransactionHistory(walletAddress, emit);
      case LoadMoreTransactionsAction(:final walletAddress):
        await _loadMoreTransactions(walletAddress, emit);
    }
  }

  Future<void> _loadTransactionHistory(
    String walletAddress,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(const TransactionHistoryLoading());

    final result = await getTransactionHistoryUseCase(
      walletAddress: walletAddress,
      limit: _pageSize,
      offset: 0,
    );

    result.fold(
      (failure) {
        emit(TransactionHistoryError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (transactions) {
        if (transactions.isEmpty) {
          emit(const TransactionHistoryEmpty());
        } else {
          _currentOffset = transactions.length;
          emit(TransactionHistoryLoaded(
            transactions: transactions,
            hasMore: transactions.length >= _pageSize,
          ));
        }
      },
    );
  }

  Future<void> _loadMoreTransactions(
    String walletAddress,
    Emitter<TransactionHistoryState> emit,
  ) async {
    if (state is! TransactionHistoryLoaded) return;

    final currentState = state as TransactionHistoryLoaded;
    emit(TransactionHistoryLoadingMore(currentState.transactions));

    final result = await getTransactionHistoryUseCase(
      walletAddress: walletAddress,
      limit: _pageSize,
      offset: _currentOffset,
    );

    result.fold(
      (failure) {
        emit(TransactionHistoryLoaded(
          transactions: currentState.transactions,
          hasMore: false,
        ));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (newTransactions) {
        _currentOffset += newTransactions.length;
        emit(TransactionHistoryLoaded(
          transactions: [...currentState.transactions, ...newTransactions],
          hasMore: newTransactions.length >= _pageSize,
        ));
      },
    );
  }
}
```

#### 5.5 Create Page
**File**: `lib/features/transaction_history/presentation/pages/transaction_history_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../mvi/transaction_history_bloc.dart';
import '../mvi/transaction_history_action.dart';
import '../mvi/transaction_history_state.dart';
import '../mvi/transaction_history_event.dart';

class TransactionHistoryPage extends StatelessWidget {
  final String walletAddress;

  const TransactionHistoryPage({
    super.key,
    required this.walletAddress,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransactionHistoryBloc>()
        ..onAction(LoadTransactionHistoryAction(walletAddress)),
      child: _TransactionHistoryView(walletAddress: walletAddress),
    );
  }
}

class _TransactionHistoryView extends StatefulWidget {
  final String walletAddress;

  const _TransactionHistoryView({required this.walletAddress});

  @override
  State<_TransactionHistoryView> createState() =>
      _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<_TransactionHistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context
          .read<TransactionHistoryBloc>()
          .onAction(LoadMoreTransactionsAction(widget.walletAddress));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<TransactionHistoryBloc>()
                  .onAction(RefreshTransactionHistoryAction(widget.walletAddress));
            },
          ),
        ],
      ),
      body: BlocConsumer<TransactionHistoryBloc, TransactionHistoryState>(
        listener: (context, state) {
          context.read<TransactionHistoryBloc>().events.listen((event) {
            switch (event) {
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: Colors.green),
                );
              case ShowErrorMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: Colors.red),
                );
              case NavigateToTransactionDetail(:final transactionId):
                // Navigate to detail page
                break;
            }
          });
        },
        builder: (context, state) {
          return switch (state) {
            TransactionHistoryLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            TransactionHistoryEmpty() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No transactions found'),
                  ],
                ),
              ),
            TransactionHistoryLoaded(:final transactions, :final hasMore) =>
              ListView.builder(
                controller: _scrollController,
                itemCount: transactions.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= transactions.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final tx = transactions[index];
                  return ListTile(
                    leading: _getStatusIcon(tx.status),
                    title: Text('${tx.amount} ${tx.currency}'),
                    subtitle: Text(tx.type),
                    trailing: Text(_formatDate(tx.timestamp)),
                    onTap: () {
                      context
                          .read<TransactionHistoryBloc>()
                          .emitEvent(NavigateToTransactionDetail(tx.id));
                    },
                  );
                },
              ),
            TransactionHistoryError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $message'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TransactionHistoryBloc>().onAction(
                              RefreshTransactionHistoryAction(widget.walletAddress),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }

  Widget _getStatusIcon(TransactionStatus status) {
    return switch (status) {
      TransactionStatus.completed => const Icon(Icons.check_circle, color: Colors.green),
      TransactionStatus.failed => const Icon(Icons.error, color: Colors.red),
      TransactionStatus.pending => const Icon(Icons.pending, color: Colors.orange),
    };
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

### Step 6: Run Code Generation

```bash
cd /Users/danhdue/AllProjects/sample/bloc_digital_wallet
flutter pub run build_runner build --delete-conflicting-outputs
```

**Verify**: Check that these files are generated:
- `transaction_history_model.freezed.dart`
- `transaction_history_model.g.dart`
- `lib/di/injection.config.dart` (updated)

### Step 7: Format and Analyze

**🔍 CRITICAL: Double Check (Run these commands):**

```bash
# 1. Format all code
flutter format .

# 2. Analyze code (MUST show "No issues found!")
flutter analyze --no-fatal-infos

# Expected output:
# Analyzing bloc_digital_wallet...
# No issues found! (ran in X.Xs)

# 3. If ANY issues found:
#    - Read error messages
#    - Fix each issue
#    - Run flutter analyze again
#    - Repeat until 0 issues
```

**Fix any issues** reported by analyzer. **DO NOT proceed** until output is `"No issues found!"`

### Step 8: Test (Optional)

Create test file:
**File**: `test/features/transaction_history/domain/usecases/get_transaction_history_usecase_test.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Add tests here
```

### Step 9: Report to User

```
✅ Feature "transaction_history" created successfully!

Files created:
- Domain: 1 entity, 1 repository interface, 1 use case
- Data: 1 model, 1 remote data source, 1 repository implementation
- Presentation: 1 action file, 1 state file, 1 event file, 1 BLoC, 1 page

Next steps:
1. Update API endpoint in RemoteDataSource (currently placeholder)
2. Add navigation route in main.dart
3. Test the feature

To navigate to this feature:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TransactionHistoryPage(walletAddress: 'your_address'),
  ),
);
```

---

## Workflow: Add New API Endpoint Integration

**Scenario**: User says "Add API endpoint to get user profile"

### Step 1: Identify Feature
```
Endpoint: GET /api/v1/user/profile
Feature: user_profile (if new) OR add to existing user feature
```

### Step 2: Update Remote Data Source

**File**: `lib/features/user/data/datasources/user_remote_datasource.dart`

```dart
abstract class UserRemoteDataSource {
  // Existing methods...
  
  Future<UserProfileModel> getUserProfile(String userId);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  const UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await dio.get('/api/v1/user/profile/$userId');
      
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get user profile',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        originalException: e,
      );
    }
  }
}
```

### Step 3: Update Repository

**File**: `lib/features/user/data/repositories/user_repository_impl.dart`

```dart
@override
Future<Either<Failure, UserProfileEntity>> getUserProfile(String userId) async {
  try {
    final remoteData = await remoteDataSource.getUserProfile(userId);
    return Right(remoteData.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message, code: e.code));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message, code: e.code));
  }
}
```

### Step 4: Update Repository Interface

**File**: `lib/features/user/domain/repositories/user_repository.dart`

```dart
abstract class UserRepository {
  // Existing methods...
  
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String userId);
}
```

### Step 5: Create Use Case

**File**: `lib/features/user/domain/usecases/get_user_profile_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/user_repository.dart';

@injectable
class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(String userId) async {
    if (userId.isEmpty) {
      return Left(ValidationFailure(message: 'User ID is required'));
    }
    
    return await repository.getUserProfile(userId);
  }
}
```

### Step 6: Add to BLoC

**File**: `lib/features/user/presentation/mvi/user_bloc.dart`

```dart
@injectable
class UserBloc extends MviBloc<UserAction, UserState, UserEvent> {
  final GetUserProfileUseCase getUserProfileUseCase; // Add this

  UserBloc({
    required this.getUserProfileUseCase, // Add this
  }) : super(const UserInitial());

  @override
  Future<void> onAction(UserAction action, Emitter<UserState> emit) async {
    switch (action) {
      case LoadUserProfileAction(:final userId):
        await _onLoadUserProfile(userId, emit);
      // Other cases...
    }
  }

  Future<void> _onLoadUserProfile(
    String userId,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    
    final result = await getUserProfileUseCase(userId);
    
    result.fold(
      (failure) {
        emit(UserError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (profile) {
        emit(UserProfileLoaded(profile));
      },
    );
  }
}
```

### Step 7: Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Workflow: Fix Bug in Existing Feature

**Scenario**: User reports "Wallet balance not updating after transaction"

### Step 1: Locate Feature
```
Feature: wallet
Path: lib/features/wallet/
```

### Step 2: Identify Layer
```
Issue: UI not updating → Check Presentation (BLoC)
Issue: Wrong data → Check Data (Repository/DataSource)
Issue: Wrong calculation → Check Domain (UseCase)
```

### Step 3: Debug BLoC

**Check**: `lib/features/wallet/presentation/mvi/wallet_bloc.dart`

```dart
// Look for action handler
case UpdateWalletBalanceAction(:final newBalance):
  emit(state.copyWith(balance: newBalance)); // Is emit() called?
```

**Common Issues**:
- `emit()` not called
- Wrong state property updated
- State not using `copyWith()`
- State missing from `props` getter

### Step 4: Check State Definition

**File**: `lib/features/wallet/presentation/mvi/wallet_state.dart`

```dart
class WalletLoaded extends WalletState {
  final double balance;
  
  const WalletLoaded({required this.balance});
  
  @override
  List<Object?> get props => [balance]; // Ensure balance is in props!
  
  WalletLoaded copyWith({double? balance}) {
    return WalletLoaded(balance: balance ?? this.balance);
  }
}
```

### Step 5: Check Action Dispatching

**File**: `lib/features/wallet/presentation/pages/wallet_page.dart`

```dart
// After transaction completes
context.read<WalletBloc>().onAction(
  UpdateWalletBalanceAction(newBalance), // Is this called?
);
```

### Step 6: Add Logging (if needed)

```dart
Future<void> _onUpdateBalance(
  UpdateWalletBalanceAction action,
  Emitter<WalletState> emit,
) async {
  debugPrint('📝 Updating balance to: ${action.newBalance}');
  emit(state.copyWith(balance: action.newBalance));
  debugPrint('✅ Balance updated');
}
```

### Step 7: Test Fix

```bash
# Run the app
flutter run

# Or run specific test
flutter test test/features/wallet/presentation/bloc/wallet_bloc_test.dart
```

### Step 8: Report Resolution

```
✅ Bug fixed: Wallet balance now updates after transaction

Root Cause: State property 'balance' was missing from props getter

Fix Applied:
- File: lib/features/wallet/presentation/mvi/wallet_state.dart
- Added 'balance' to props list
- Ensures BlocBuilder detects state changes

Testing: Verified balance updates in UI after transaction
```

---

## Workflow: Add New Use Case to Existing Feature

**Scenario**: User requests "Add ability to export wallet transactions to PDF"

### Step 1: Identify Feature
```
Feature: wallet
New Use Case: ExportWalletTransactionsToPdfUseCase
```

### Step 2: Create Use Case File

**File**: `lib/features/wallet/domain/usecases/export_wallet_transactions_to_pdf_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/wallet_repository.dart';

@injectable
class ExportWalletTransactionsToPdfUseCase {
  final WalletRepository repository;

  ExportWalletTransactionsToPdfUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String walletAddress,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Business logic validation
    if (endDate.isBefore(startDate)) {
      return Left(ValidationFailure(message: 'End date must be after start date'));
    }

    return await repository.exportTransactionsToPdf(
      walletAddress: walletAddress,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
```

### Step 3: Update Repository Interface

**File**: `lib/features/wallet/domain/repositories/wallet_repository.dart`

```dart
abstract class WalletRepository {
  // Existing methods...
  
  Future<Either<Failure, String>> exportTransactionsToPdf({
    required String walletAddress,
    required DateTime startDate,
    required DateTime endDate,
  });
}
```

### Step 4: Implement in Repository

**File**: `lib/features/wallet/data/repositories/wallet_repository_impl.dart`

```dart
@override
Future<Either<Failure, String>> exportTransactionsToPdf({
  required String walletAddress,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    final pdfPath = await remoteDataSource.exportTransactionsToPdf(
      walletAddress: walletAddress,
      startDate: startDate,
      endDate: endDate,
    );
    return Right(pdfPath);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message, code: e.code));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message, code: e.code));
  }
}
```

### Step 5: Add to Data Source

**File**: `lib/features/wallet/data/datasources/wallet_remote_datasource.dart`

```dart
abstract class WalletRemoteDataSource {
  // Existing methods...
  
  Future<String> exportTransactionsToPdf({
    required String walletAddress,
    required DateTime startDate,
    required DateTime endDate,
  });
}

// Implementation
@override
Future<String> exportTransactionsToPdf({
  required String walletAddress,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    final response = await dio.post(
      '/wallet/export/pdf',
      data: {
        'wallet_address': walletAddress,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );
    
    if (response.statusCode == 200) {
      return response.data['pdf_url']; // Or local file path
    } else {
      throw ServerException(message: 'Export failed', code: response.statusCode);
    }
  } on DioException catch (e) {
    throw NetworkException(message: e.message ?? 'Network error', originalException: e);
  }
}
```

### Step 6: Add Action

**File**: `lib/features/wallet/presentation/mvi/wallet_action.dart`

```dart
class ExportTransactionsToPdfAction extends WalletAction {
  final String walletAddress;
  final DateTime startDate;
  final DateTime endDate;

  const ExportTransactionsToPdfAction({
    required this.walletAddress,
    required this.startDate,
    required this.endDate,
  });
}
```

### Step 7: Add Event

**File**: `lib/features/wallet/presentation/mvi/wallet_event.dart`

```dart
class PdfExportedSuccessfully extends WalletEvent {
  final String pdfPath;
  const PdfExportedSuccessfully(this.pdfPath);
}
```

### Step 8: Handle in BLoC

**File**: `lib/features/wallet/presentation/mvi/wallet_bloc.dart`

```dart
@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final ExportWalletTransactionsToPdfUseCase exportToPdfUseCase; // Add

  WalletBloc({
    required this.exportToPdfUseCase, // Add
  }) : super(const WalletInitial());

  @override
  Future<void> onAction(WalletAction action, Emitter<WalletState> emit) async {
    switch (action) {
      case ExportTransactionsToPdfAction(:final walletAddress, :final startDate, :final endDate):
        await _onExportToPdf(walletAddress, startDate, endDate, emit);
      // Other cases...
    }
  }

  Future<void> _onExportToPdf(
    String walletAddress,
    DateTime startDate,
    DateTime endDate,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletExporting());
    
    final result = await exportToPdfUseCase(
      walletAddress: walletAddress,
      startDate: startDate,
      endDate: endDate,
    );
    
    result.fold(
      (failure) {
        emit(WalletError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (pdfPath) {
        emit(state); // Return to previous state
        emitEvent(PdfExportedSuccessfully(pdfPath));
        emitEvent(const ShowSuccessMessage('PDF exported successfully!'));
      },
    );
  }
}
```

### Step 9: Update UI

**File**: `lib/features/wallet/presentation/pages/wallet_page.dart`

```dart
// Add export button
FloatingActionButton(
  onPressed: () {
    // Show date picker dialog, then:
    context.read<WalletBloc>().onAction(
      ExportTransactionsToPdfAction(
        walletAddress: walletAddress,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  },
  child: const Icon(Icons.picture_as_pdf),
),

// Handle event
case PdfExportedSuccessfully(:final pdfPath):
  // Open PDF or share
  Share.shareFiles([pdfPath]);
```

### Step 10: Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Workflow: Update Entity/Model

**Scenario**: User says "Add 'email' field to User entity"

### Step 1: Update Entity

**File**: `lib/features/user/domain/entities/user_entity.dart`

```dart
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email; // Add this

  const UserEntity({
    required this.id,
    required this.name,
    required this.email, // Add this
  });

  @override
  List<Object?> get props => [id, name, email]; // Add email to props
}
```

### Step 2: Update Model

**File**: `lib/features/user/data/models/user_model.dart`

```dart
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String email, // Add this
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email, // Add this
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email, // Add this
      );
}
```

### Step 3: Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will regenerate:
- `user_model.freezed.dart`
- `user_model.g.dart`

### Step 4: Update UI (if needed)

**File**: `lib/features/user/presentation/pages/user_profile_page.dart`

```dart
// Display email
Text('Email: ${user.email}'),
```

### Step 5: Test

```bash
flutter test test/features/user/
```

---

## Workflow: Handle Dependency Conflicts

**Scenario**: `flutter pub get` fails with version conflict

### Step 1: Read Error Message

```
Because package_a 1.0.0 depends on package_b ^2.0.0 
and package_c 1.0.0 depends on package_b ^3.0.0,
package_a 1.0.0 is incompatible with package_c 1.0.0.
```

### Step 2: Identify Conflicting Packages

```
Conflicting: package_b
Required by: package_a (needs ^2.0.0), package_c (needs ^3.0.0)
```

### Step 3: Check Latest Versions

```bash
flutter pub outdated
```

### Step 4: Update pubspec.yaml

**Option A**: Update one package to compatible version

```yaml
dependencies:
  package_a: ^2.0.0  # Updated version that supports package_b ^3.0.0
  package_c: ^1.0.0
```

**Option B**: Use dependency_overrides (last resort)

```yaml
dependency_overrides:
  package_b: ^3.0.0
```

### Step 5: Run pub get

```bash
flutter pub get
```

### Step 6: Test

```bash
flutter analyze
flutter test
```

### Step 7: Report

```
✅ Dependency conflict resolved

Updated: package_a from 1.0.0 to 2.0.0
Reason: package_a 2.0.0 supports package_b ^3.0.0

No breaking changes detected.
```

---

## Workflow: Debug State Management Issues

**Scenario**: "BLoC state changes but UI doesn't update"

### Step 1: Check BlocProvider

```dart
// Ensure BlocProvider wraps the widget tree
BlocProvider(
  create: (_) => getIt<WalletBloc>(),
  child: WalletPage(),
)
```

### Step 2: Check BlocBuilder/BlocConsumer

```dart
// Ensure BlocBuilder is used
BlocBuilder<WalletBloc, WalletState>(
  builder: (context, state) {
    // UI here
  },
)
```

### Step 3: Check State Equality

```dart
// Ensure State has correct props
class WalletLoaded extends WalletState {
  final double balance;
  
  @override
  List<Object?> get props => [balance]; // Must include all fields!
}
```

### Step 4: Check emit() is Called

```dart
Future<void> _onLoadWallet(
  LoadWalletAction action,
  Emitter<WalletState> emit,
) async {
  emit(const WalletLoading()); // ✅ emit() is called
  // ...
  emit(WalletLoaded(wallet)); // ✅ emit() is called
}
```

### Step 5: Check Action Dispatching

```dart
// Correct way
context.read<WalletBloc>().onAction(LoadWalletAction());

// Wrong way (don't use)
context.read<WalletBloc>().add(LoadWalletAction()); // ❌
```

### Step 6: Add Debug Logging

```dart
@override
Future<void> onAction(WalletAction action, Emitter<WalletState> emit) async {
  debugPrint('🔵 Action received: ${action.runtimeType}');
  // ... handle action ...
  debugPrint('🟢 State emitted: ${state.runtimeType}');
}
```

### Step 7: Check BLoC Lifecycle

```dart
// Ensure BLoC is not disposed too early
@override
void dispose() {
  // BLoC should be disposed by BlocProvider, not manually
  super.dispose();
}
```

---

## Workflow: Add Unit Tests

**Scenario**: User asks "Add tests for GetWalletUseCase"

### Step 1: Create Test File

**File**: `test/features/wallet/domain/usecases/get_wallet_usecase_test.dart`

### Step 2: Set Up Test Structure

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/usecases/get_wallet_usecase.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late GetWalletUseCase useCase;
  late MockWalletRepository mockRepository;

  setUp(() {
    mockRepository = MockWalletRepository();
    useCase = GetWalletUseCase(mockRepository);
  });

  // Tests go here
}
```

### Step 3: Write Success Test

```dart
test('should return WalletEntity when repository succeeds', () async {
  // Arrange
  const tWalletAddress = '0x123';
  const tWallet = WalletEntity(
    address: tWalletAddress,
    balance: 100.0,
  );
  
  when(() => mockRepository.getWallet(any()))
      .thenAnswer((_) async => const Right(tWallet));

  // Act
  final result = await useCase(tWalletAddress);

  // Assert
  expect(result, const Right(tWallet));
  verify(() => mockRepository.getWallet(tWalletAddress)).called(1);
  verifyNoMoreInteractions(mockRepository);
});
```

### Step 4: Write Failure Test

```dart
test('should return ServerFailure when repository fails', () async {
  // Arrange
  const tWalletAddress = '0x123';
  const tFailure = ServerFailure(message: 'Server error', code: 500);
  
  when(() => mockRepository.getWallet(any()))
      .thenAnswer((_) async => const Left(tFailure));

  // Act
  final result = await useCase(tWalletAddress);

  // Assert
  expect(result, const Left(tFailure));
  verify(() => mockRepository.getWallet(tWalletAddress)).called(1);
});
```

### Step 5: Write Validation Test

```dart
test('should return ValidationFailure when address is empty', () async {
  // Act
  final result = await useCase('');

  // Assert
  expect(result.isLeft(), true);
  result.fold(
    (failure) => expect(failure, isA<ValidationFailure>()),
    (_) => fail('Should return failure'),
  );
  verifyZeroInteractions(mockRepository);
});
```

### Step 6: Run Tests

```bash
flutter test test/features/wallet/domain/usecases/get_wallet_usecase_test.dart
```

### Step 7: Check Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Workflow: Refactor Existing Code

**Scenario**: User says "Refactor WalletBloc to separate concerns"

### Step 1: Identify Refactoring Goal

```
Current: WalletBloc handles wallet operations AND transaction operations
Goal: Split into WalletBloc and TransactionBloc
```

### Step 2: Create New BLoC Structure

**New File**: `lib/features/wallet/presentation/mvi/transaction_bloc.dart`

```dart
@injectable
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  final GetTransactionsUseCase getTransactionsUseCase;
  
  TransactionBloc({required this.getTransactionsUseCase})
      : super(const TransactionInitial());
  
  @override
  Future<void> onAction(
    TransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    // Handle transaction actions
  }
}
```

### Step 3: Move Related Code

**Move from WalletBloc to TransactionBloc**:
- Transaction-related Actions
- Transaction-related States
- Transaction-related Events
- Transaction-related action handlers

### Step 4: Update UI

**File**: `lib/features/wallet/presentation/pages/wallet_page.dart`

```dart
// Before (single BLoC)
BlocProvider(
  create: (_) => getIt<WalletBloc>(),
  child: WalletView(),
)

// After (multiple BLoCs)
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => getIt<WalletBloc>()),
    BlocProvider(create: (_) => getIt<TransactionBloc>()),
  ],
  child: WalletView(),
)
```

### Step 5: Update Action Dispatching

```dart
// Before
context.read<WalletBloc>().onAction(LoadTransactionsAction());

// After
context.read<TransactionBloc>().onAction(LoadTransactionsAction());
```

### Step 6: Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 7: Test Refactoring

```bash
flutter analyze
flutter test
flutter run
```

### Step 8: Report Changes

```
✅ Refactoring complete: Separated WalletBloc into WalletBloc and TransactionBloc

Changes:
- Created TransactionBloc for transaction operations
- WalletBloc now only handles wallet data
- Updated UI to use MultiBlocProvider
- All tests passing

Benefits:
- Better separation of concerns
- Easier to maintain
- More testable
```

---

## Workflow: Performance Optimization

**Scenario**: User reports "App is slow when loading large transaction list"

### Step 1: Identify Bottleneck

**Common bottlenecks**:
- Loading all data at once
- No pagination
- Heavy computations in build()
- No caching

### Step 2: Implement Pagination

**Update Use Case**:

```dart
@injectable
class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call({
    int limit = 20,  // Add pagination
    int offset = 0,  // Add pagination
  }) async {
    return await repository.getTransactions(
      limit: limit,
      offset: offset,
    );
  }
}
```

### Step 3: Update BLoC with Pagination

```dart
@injectable
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  final GetTransactionsUseCase getTransactionsUseCase;
  
  int _currentOffset = 0;
  static const int _pageSize = 20;

  @override
  Future<void> onAction(
    TransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    switch (action) {
      case LoadMoreTransactionsAction():
        await _loadMore(emit);
    }
  }

  Future<void> _loadMore(Emitter<TransactionState> emit) async {
    if (state is! TransactionLoaded) return;
    
    final currentState = state as TransactionLoaded;
    
    final result = await getTransactionsUseCase(
      limit: _pageSize,
      offset: _currentOffset,
    );
    
    result.fold(
      (failure) => emitEvent(ShowErrorMessage(failure.message)),
      (newTransactions) {
        _currentOffset += newTransactions.length;
        emit(TransactionLoaded(
          transactions: [...currentState.transactions, ...newTransactions],
          hasMore: newTransactions.length >= _pageSize,
        ));
      },
    );
  }
}
```

### Step 4: Add Lazy Loading to UI

```dart
ListView.builder(
  controller: _scrollController,
  itemCount: transactions.length + (hasMore ? 1 : 0),
  itemBuilder: (context, index) {
    if (index >= transactions.length) {
      // Load more when scrolled to bottom
      context.read<TransactionBloc>().onAction(LoadMoreTransactionsAction());
      return const CircularProgressIndicator();
    }
    
    return TransactionItem(transaction: transactions[index]);
  },
)
```

### Step 5: Add Caching

**Update Repository**:

```dart
@override
Future<Either<Failure, List<TransactionEntity>>> getTransactions({
  int limit = 20,
  int offset = 0,
}) async {
  try {
    // Try cache first
    if (offset == 0) {
      final cachedData = await localDataSource.getCachedTransactions();
      if (cachedData.isNotEmpty) {
        return Right(cachedData.map((m) => m.toEntity()).toList());
      }
    }
    
    // Fetch from remote
    final remoteData = await remoteDataSource.getTransactions(
      limit: limit,
      offset: offset,
    );
    
    // Cache the result
    if (offset == 0) {
      await localDataSource.cacheTransactions(remoteData);
    }
    
    return Right(remoteData.map((m) => m.toEntity()).toList());
  } catch (e) {
    // Error handling
  }
}
```

### Step 6: Use const Constructors

```dart
// Before
return Container(
  child: Text('Hello'),
);

// After
return const SizedBox(
  child: Text('Hello'),
);
```

### Step 7: Measure Performance

```bash
# Run in profile mode
flutter run --profile

# Check performance
flutter run --profile --trace-startup
```

### Step 8: Report Optimization

```
✅ Performance optimized

Changes:
1. Added pagination (20 items per page)
2. Implemented lazy loading on scroll
3. Added caching for first page
4. Used const constructors where possible

Results:
- Initial load time: reduced by 60%
- Memory usage: reduced by 40%
- Smooth scrolling for 1000+ items
```

---

## 🔍 CRITICAL: Double Check Before Reporting

**⚠️ MANDATORY STEP AFTER EVERY TASK**

Before reporting completion to the user, **ALWAYS** run these verification steps:

### Step-by-Step Verification

```bash
# Step 1: Format all code
flutter format .

# Step 2: Run analyzer (MUST show "No issues found!")
flutter analyze --no-fatal-infos

# Step 3: Check output
# ✅ Success: "No issues found! (ran in X.Xs)"
# ❌ Failure: Any errors, warnings, or info messages

# Step 4: If issues found:
#    a. Read each error message carefully
#    b. Fix the issue in the affected file
#    c. Run flutter analyze again
#    d. Repeat until "No issues found!"

# Step 5: Run tests (if applicable)
flutter test

# Step 6: Verify code generation (if models/DI changed)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Expected Success Output

```
$ flutter analyze --no-fatal-infos
Analyzing bloc_digital_wallet...
No issues found! (ran in 1.5s)
```

### What to Do If Errors Found

**Example Error:**
```
lib/features/wallet/data/models/wallet_model.dart:15:7: 
error • Missing type annotation • strict_top_level_inference
```

**Fix Process:**
1. ✅ Open the file: `lib/features/wallet/data/models/wallet_model.dart`
2. ✅ Go to line 15, column 7
3. ✅ Read the error: "Missing type annotation"
4. ✅ Fix: Add the missing type
5. ✅ Run `flutter analyze --no-fatal-infos` again
6. ✅ Verify: "No issues found!"

### Common Issues & Quick Fixes

| Error | Quick Fix |
|-------|-----------|
| Missing type annotation | Add explicit return type |
| Undefined name | Add import or fix spelling |
| Unused import | Remove the import |
| Angle brackets in doc comment | Use different phrasing |
| Missing @override | Add @override annotation |

### Success Checklist

Before reporting to user, verify:

- [ ] `flutter format .` completed
- [ ] `flutter analyze --no-fatal-infos` shows **"No issues found!"**
- [ ] Exit code is **0**
- [ ] No errors, warnings, or info messages
- [ ] Tests pass (if applicable)
- [ ] Code generation completed (if needed)
- [ ] All files saved

### ⚠️ Important Notes

1. **DO NOT skip this step** - It's mandatory for every task
2. **DO NOT report completion** until 0 issues
3. **DO NOT ignore warnings** - Fix them all
4. **DO report** what you fixed if any issues were found

### Example Report

**Good Report (No Issues):**
```
✅ Task completed: Created transaction history feature

Changes:
- Created domain entities and use cases
- Implemented data layer with remote/local sources
- Built presentation layer with MVI pattern

Verification:
✅ flutter analyze: No issues found!
✅ All code formatted
✅ Architecture compliance verified

Files created: 15 files across domain/data/presentation layers
```

**Good Report (Issues Fixed):**
```
✅ Task completed: Created transaction history feature

Changes:
- Created domain entities and use cases
- Implemented data layer with remote/local sources
- Built presentation layer with MVI pattern

Issues Fixed:
- Fixed 2 missing type annotations in use cases
- Removed 1 unused import
- Fixed doc comment formatting

Verification:
✅ flutter analyze: No issues found!
✅ All code formatted
✅ Architecture compliance verified

Files created: 15 files across domain/data/presentation layers
```

---

## Summary

These workflows provide step-by-step guidance for common tasks:

1. ✅ Create complete new feature
2. ✅ Add new API endpoint integration
3. ✅ Fix bugs in existing features
4. ✅ Add new use cases
5. ✅ Update entities/models
6. ✅ Handle dependency conflicts
7. ✅ Debug state management
8. ✅ Add unit tests
9. ✅ Refactor code
10. ✅ Optimize performance

**For context and architecture rules, see: AI_AGENT_CONTEXT.md**
