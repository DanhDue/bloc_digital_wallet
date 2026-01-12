// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{feature_name.snakeCase()}}}_entity.dart';
import '../repositories/{{{feature_name.snakeCase()}}}_repository.dart';

@injectable
class GetAll{{feature_name.pascalCase()}}sUseCase {
  final {{feature_name.pascalCase()}}Repository repository;

  GetAll{{feature_name.pascalCase()}}sUseCase(this.repository);

  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> call() async {
    return await repository.getAll{{feature_name.pascalCase()}}s();
  }
}
