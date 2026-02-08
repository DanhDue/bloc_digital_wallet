// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:trends/domain/entities/trends_entity.dart';

abstract class TrendsRepository {
  Future<Either<Failure, TrendsEntity>> getTrends();
}
