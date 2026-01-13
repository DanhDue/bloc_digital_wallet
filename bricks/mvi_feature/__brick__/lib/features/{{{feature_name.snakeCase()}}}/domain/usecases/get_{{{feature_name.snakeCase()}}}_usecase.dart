// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{{{feature_name.snakeCase()}}}_entity.dart';
import '../repositories/{{{feature_name.snakeCase()}}}_repository.dart';

@injectable
class Get{{feature_name.pascalCase()}}UseCase {
  final {{feature_name.pascalCase()}}Repository repository;

  Get{{feature_name.pascalCase()}}UseCase(this.repository);

  /// Get all {{feature_name.lowerCase()}}s
  Future<Either<Failure, List<{{feature_name.pascalCase()}}Entity>>> call() async {
    return await repository.get{{feature_name.pascalCase()}}s();
  }
}
