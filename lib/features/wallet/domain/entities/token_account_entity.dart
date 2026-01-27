// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'mint_token_entity.dart';

part 'token_account_entity.freezed.dart';

@freezed
abstract class TokenAccountEntity with _$TokenAccountEntity {
  const TokenAccountEntity._();

  const factory TokenAccountEntity({
    String? address,
    String? owner,
    double? amount,
    MintTokenEntity? mintToken,
    String? accountOwner,
  }) = _TokenAccountEntity;
}
