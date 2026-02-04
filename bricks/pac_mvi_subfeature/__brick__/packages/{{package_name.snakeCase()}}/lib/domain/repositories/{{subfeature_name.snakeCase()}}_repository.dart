// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import '../entities/{{subfeature_name.snakeCase()}}_entity.dart';

abstract class {{subfeature_name.pascalCase()}}Repository {
  Future<Either<Failure, {{subfeature_name.pascalCase()}}Entity>> get{{subfeature_name.pascalCase()}}();
}
