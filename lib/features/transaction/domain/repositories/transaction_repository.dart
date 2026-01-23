// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// TODO: Uncomment imports when adding methods
// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failures.dart';
// import '../entities/transaction_entity.dart';

/// ============================================================================
/// Transaction Repository (Interface)
/// ============================================================================
/// Repository interfaces define the contract for data operations.
/// They belong in the domain layer and should be implementation-agnostic.
///
/// HOW TO IMPLEMENT:
/// 1. Define methods for each data operation needed
/// 2. Return Either<Failure, T> for error handling
/// 3. Use domain entities as return types (not data models)
///
/// EXAMPLE - Adding repository methods:
/// ```dart
/// abstract class TransactionRepository {
///   /// Get all items
///   Future<Either<Failure, List<TransactionEntity>>> getAll();
///
///   /// Get item by ID
///   Future<Either<Failure, TransactionEntity>> getById(String id);
///
///   /// Create new item
///   Future<Either<Failure, TransactionEntity>> create(TransactionEntity entity);
///
///   /// Update existing item
///   Future<Either<Failure, TransactionEntity>> update(TransactionEntity entity);
///
///   /// Delete item
///   Future<Either<Failure, void>> delete(String id);
/// }
/// ```
///
/// BEST PRACTICES:
/// - Keep methods focused on single responsibility
/// - Use descriptive method names
/// - Document expected failure types in comments
/// ============================================================================

abstract class TransactionRepository {
  // TODO: Define repository methods
  // Example:
  // Future<Either<Failure, List<TransactionEntity>>> getAll();
}
