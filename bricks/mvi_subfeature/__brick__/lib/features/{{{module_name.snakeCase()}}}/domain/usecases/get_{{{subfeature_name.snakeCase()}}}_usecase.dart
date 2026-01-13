// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{entity_name.snakeCase()}}}_entity.dart';
{{#needs_model}}import '../repositories/{{{module_name.snakeCase()}}}_repository.dart';{{/needs_model}}{{^needs_model}}// import '../repositories/{{{module_name.snakeCase()}}}_repository.dart';{{/needs_model}}

/// Use case for {{subfeature_name.titleCase()}} feature in {{module_name.titleCase()}} module
@injectable
class Get{{subfeature_name.pascalCase()}}UseCase {
  {{#needs_model}}final {{module_name.pascalCase()}}Repository repository;{{/needs_model}}
  
  Get{{subfeature_name.pascalCase()}}UseCase({{#needs_model}}this.repository{{/needs_model}});

  /// Execute the {{subfeature_name.titleCase()}} use case
  /// 
  /// Returns:
  ///   - Either<Failure, List<{{entity_name.pascalCase()}}Entity>> - Result of the operation
  Future<Either<Failure, List<{{entity_name.pascalCase()}}Entity>>> call() async {
    {{#needs_model}}
    // Assuming the subfeature works with the module's main entity list.
    // If entity_name differs from module_name, manual adjustment may be required.
    return await repository.get{{module_name.pascalCase()}}s() as Future<Either<Failure, List<{{entity_name.pascalCase()}}Entity>>>;
    {{/needs_model}}
    {{^needs_model}}
    throw UnimplementedError('Implement Get{{subfeature_name.pascalCase()}}UseCase.call()');
    {{/needs_model}}
  }
}
