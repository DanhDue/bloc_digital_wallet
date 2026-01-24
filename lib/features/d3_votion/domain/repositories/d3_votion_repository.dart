// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// TODO: Uncomment imports when adding methods
// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failures.dart';
// import '../entities/d3_votion_entity.dart';

/// ============================================================================
/// D3Votion Repository (Interface)
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
/// abstract class D3VotionRepository {
///   /// Get all items
///   Future<Either<Failure, List<D3VotionEntity>>> getAll();
///
///   /// Get item by ID
///   Future<Either<Failure, D3VotionEntity>> getById(String id);
///
///   /// Create new item
///   Future<Either<Failure, D3VotionEntity>> create(D3VotionEntity entity);
///
///   /// Update existing item
///   Future<Either<Failure, D3VotionEntity>> update(D3VotionEntity entity);
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

abstract class D3VotionRepository {
  // TODO: Define repository methods
  // Example:
  // Future<Either<Failure, List<D3VotionEntity>>> getAll();
}
