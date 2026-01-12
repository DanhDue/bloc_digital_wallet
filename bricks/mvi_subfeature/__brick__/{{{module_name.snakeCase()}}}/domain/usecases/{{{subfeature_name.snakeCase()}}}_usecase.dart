// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{entity_name.snakeCase()}}}_entity.dart';
import '../repositories/{{{module_name.snakeCase()}}}_repository.dart';

/// Use case for {{subfeature_name.titleCase()}} feature in {{module_name.titleCase()}} module
@injectable
class {{subfeature_name.pascalCase()}}UseCase {
  final {{module_name.pascalCase()}}Repository _repository;

  {{subfeature_name.pascalCase()}}UseCase(this._repository);

  /// Execute the {{subfeature_name.titleCase()}} use case
  /// 
  /// Parameters:
  ///   - Add your parameters here
  /// 
  /// Returns:
  ///   - Either<Failure, {{entity_name.pascalCase()}}Entity> - Result of the operation
  Future<Either<Failure, {{entity_name.pascalCase()}}Entity>> call(
    // TODO: Add your parameters here
    String id,
  ) async {
    // TODO: Implement your business logic here
    // Example: return await _repository.{{subfeature_name.camelCase()}}(id);
    throw UnimplementedError('Implement {{subfeature_name.pascalCase()}}UseCase.call()');
  }
}
