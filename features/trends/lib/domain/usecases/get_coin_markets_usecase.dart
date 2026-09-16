// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/domain/entities/coin_market_entity.dart';
import 'package:trends/domain/repositories/trends_repository.dart';

@injectable
class GetCoinMarketsUseCase {
  final TrendsRepository _repository;

  GetCoinMarketsUseCase(this._repository);

  Future<Either<Failure, List<CoinMarketEntity>>> call({int page = 1, int limit = 20}) {
    return _repository.getCoinMarkets(page: page, limit: limit);
  }
}
