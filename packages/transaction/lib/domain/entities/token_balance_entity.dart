// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_balance_entity.freezed.dart';

@freezed
abstract class TokenBalanceEntity with _$TokenBalanceEntity {
  const TokenBalanceEntity._();

  const factory TokenBalanceEntity({
    String? address,
    String? token,
    double? changes,
    String? postBalance,
  }) = _TokenBalanceEntity;
}
