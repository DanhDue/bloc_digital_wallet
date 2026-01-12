// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{feature_name.snakeCase()}}}_entity.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  /// Get {{feature_name.lowerCase()}} by id
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> get{{feature_name.pascalCase()}}(String id);
  
  /// Get all {{feature_name.lowerCase()}}s
  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> getAll{{feature_name.pascalCase()}}s();
  
  /// Create a new {{feature_name.lowerCase()}}
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> create{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Entity entity);
  
  /// Update {{feature_name.lowerCase()}}
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> update{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Entity entity);
  
  /// Delete {{feature_name.lowerCase()}}
  Future<Either<Failure, void>> delete{{feature_name.pascalCase()}}(String id);
}
