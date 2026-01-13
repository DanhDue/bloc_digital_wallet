// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{feature_name.snakeCase()}}}_entity.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  /// Get {{feature_name.lowerCase()}} (List)
  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> get{{feature_name.pascalCase()}}s();
  

}
