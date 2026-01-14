// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// ============================================================================
/// GetDashboard UseCase
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
/// class GetDashboardUseCase {
///   final DashboardRepository _repository;
///
///   GetDashboardUseCase(this._repository);
///
///   Future<Either<Failure, List<DashboardEntity>>> call({
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
class GetDashboardUseCase {
  // TODO: Inject repository
  // final DashboardRepository _repository;

  GetDashboardUseCase();
  // GetDashboardUseCase(this._repository);

  Future<Either<Failure, List<DashboardEntity>>> call() async {
    // TODO: Implement use case logic
    // return _repository.getAll();
    return const Right([]);
  }
}
