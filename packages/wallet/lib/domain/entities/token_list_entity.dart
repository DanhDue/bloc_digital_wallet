// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_list_entity.freezed.dart';

@freezed
abstract class TokenListEntity with _$TokenListEntity {
  const TokenListEntity._();

  const factory TokenListEntity({
    required String id,
    String? name,
    String? symbol,
    String? logo,
    double? balance,
  }) = _TokenListEntity;
}
