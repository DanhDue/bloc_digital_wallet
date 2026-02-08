// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_list_entity.freezed.dart';
part 'token_list_entity.g.dart';

@freezed
abstract class TokenListEntity with _$TokenListEntity {
  const factory TokenListEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'symbol') String? symbol,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'balance') double? balance,
  }) = _TokenListEntity;

  const TokenListEntity._();

  factory TokenListEntity.fromJson(Map<String, dynamic> json) => _$TokenListEntityFromJson(json);
}
