// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:{{package_name.snakeCase()}}/domain/repositories/{{package_name.snakeCase()}}_repository.dart';

import '../entities/{{subfeature_name.snakeCase()}}_entity.dart';

@injectable
class Get{{subfeature_name.pascalCase()}}UseCase {
  final {{package_name.pascalCase()}}Repository _repository;

  Get{{subfeature_name.pascalCase()}}UseCase(this._repository);

  Future<Either<Failure, {{subfeature_name.pascalCase()}}Entity>> call() {
    return _repository.get{{subfeature_name.pascalCase()}}();
  }
}
