// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{feature_name.snakeCase()}}}_entity.dart';
// TODO: Uncomment when injecting repository
// import '../repositories/{{{feature_name.snakeCase()}}}_repository.dart';

/// ============================================================================
/// Get{{feature_name.pascalCase()}} UseCase
/// ============================================================================
/// Use cases encapsulate a single business operation.
/// They orchestrate the flow of data from repository to presentation.
/// 
/// HOW TO IMPLEMENT:
/// 1. Inject repository via constructor
/// 2. Implement call() method with business logic
/// 3. Return Either<Failure, T> for consistent error handling
/// 
/// EXAMPLE - Full use case implementation:
/// ```dart
/// @injectable
/// class Get{{feature_name.pascalCase()}}UseCase {
///   final {{feature_name.pascalCase()}}Repository _repository;
/// 
///   Get{{feature_name.pascalCase()}}UseCase(this._repository);
/// 
///   Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> call({
///     String? searchQuery,
///     int page = 1,
///   }) async {
///     // Add any business logic/validation here
///     if (searchQuery != null && searchQuery.length < 3) {
///       return Left(ValidationFailure('Search query too short'));
///     }
///     return _repository.getAll();
///   }
/// }
/// ```
/// 
/// USE CASE PATTERNS:
/// - call() with no params: Simple fetch operations
/// - call({params}): Operations needing input data
/// - Combine multiple repository calls if needed
/// - Add validation/business rules before repository call
/// ============================================================================

@injectable
class Get{{feature_name.pascalCase()}}UseCase {
  // TODO: Inject repository
  // final {{feature_name.pascalCase()}}Repository _repository;

  Get{{feature_name.pascalCase()}}UseCase();
  // Get{{feature_name.pascalCase()}}UseCase(this._repository);

  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> call() async {
    // TODO: Implement use case logic
    // return _repository.getAll();
    return const Right([]);
  }
}
