// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../usecases/get_{{{feature_name.snakeCase()}}}_usecase.dart';
import '../usecases/get_all_{{{feature_name.snakeCase()}}}s_usecase.dart';
import '../repositories/{{{feature_name.snakeCase()}}}_repository.dart';

@module
abstract class {{feature_name.pascalCase()}}DomainModule {
   // UseCases are typically factory or singleton, verified by @injectable annotation on the class itself.
   // If you need manual provision:
   // @singleton
   // Get{{feature_name.pascalCase()}}UseCase get{{feature_name.pascalCase()}}UseCase({{feature_name.pascalCase()}}Repository repo) => 
   //    Get{{feature_name.pascalCase()}}UseCase(repo);
}
