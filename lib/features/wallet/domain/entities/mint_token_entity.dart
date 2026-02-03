// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_token_entity.freezed.dart';

@freezed
abstract class MintTokenEntity with _$MintTokenEntity {
  const factory MintTokenEntity({
    String? address,
    String? symbol,
    String? name,
    int? decimals,
    String? logo,
    String? coingeckoId,
    String? status,
    bool? isVerified,
  }) = _MintTokenEntity;
}
