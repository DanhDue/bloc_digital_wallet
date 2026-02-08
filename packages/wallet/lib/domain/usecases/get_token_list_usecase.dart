// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/token_list_entity.dart';
import '../repositories/token_list_repository.dart';

@injectable
class GetTokenListUseCase {
  final TokenListRepository _repository;

  GetTokenListUseCase(this._repository);

  Future<Either<Failure, TokenListEntity>> call() {
    return _repository.getTokenList();
  }
}
