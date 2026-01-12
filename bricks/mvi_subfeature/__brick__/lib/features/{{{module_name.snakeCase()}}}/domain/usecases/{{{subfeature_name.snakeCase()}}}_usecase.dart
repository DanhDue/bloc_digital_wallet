// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{entity_name.snakeCase()}}}_entity.dart';
{{#needs_model}}import '../repositories/{{{module_name.snakeCase()}}}_repository.dart';{{/needs_model}}{{^needs_model}}// import '../repositories/{{{module_name.snakeCase()}}}_repository.dart';{{/needs_model}}

/// Use case for {{subfeature_name.titleCase()}} feature in {{module_name.titleCase()}} module
@injectable
class {{subfeature_name.pascalCase()}}UseCase {
  {{subfeature_name.pascalCase()}}UseCase();

  /// Execute the {{subfeature_name.titleCase()}} use case
  /// 
  /// Returns:
  ///   - Either<Failure, {{entity_name.pascalCase()}}Entity> - Result of the operation
  Future<Either<Failure, {{entity_name.pascalCase()}}Entity>> call() async {
    // TODO: Implement your business logic here
    // Example: return await _repository.{{subfeature_name.camelCase()}}();
    throw UnimplementedError('Implement {{subfeature_name.pascalCase()}}UseCase.call()');
  }
}
