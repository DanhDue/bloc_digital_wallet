// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';

@injectable
class Get{{name.pascalCase()}}UseCase {
  final {{name.pascalCase()}}Repository _repository;

  Get{{name.pascalCase()}}UseCase(this._repository);

  Future<Either<Failure, {{name.pascalCase()}}Entity>> call() {
    return _repository.get{{name.pascalCase()}}();
  }
}
