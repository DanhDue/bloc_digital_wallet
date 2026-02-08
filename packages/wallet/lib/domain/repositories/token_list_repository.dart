// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import '../entities/token_list_entity.dart';

abstract class TokenListRepository {
  Future<Either<Failure, TokenListEntity>> getTokenList();
}
