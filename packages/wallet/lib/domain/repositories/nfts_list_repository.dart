// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import '../entities/nfts_list_entity.dart';

abstract class NftsListRepository {
  Future<Either<Failure, NftsListEntity>> getNftsList();
}
