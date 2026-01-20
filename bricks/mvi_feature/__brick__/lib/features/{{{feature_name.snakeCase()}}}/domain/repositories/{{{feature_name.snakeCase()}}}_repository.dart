// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// TODO: Uncomment imports when adding methods
// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failures.dart';
// import '../entities/{{{feature_name.snakeCase()}}}_entity.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Repository (Interface)
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
/// abstract class {{feature_name.pascalCase()}}Repository {
///   /// Get all items
///   Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> getAll();
/// 
///   /// Get item by ID
///   Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> getById(String id);
/// 
///   /// Create new item
///   Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> create({{feature_name.pascalCase()}}Entity entity);
/// 
///   /// Update existing item
///   Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> update({{feature_name.pascalCase()}}Entity entity);
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

abstract class {{feature_name.pascalCase()}}Repository {
  // TODO: Define repository methods
  // Example:
  // Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> getAll();
}
