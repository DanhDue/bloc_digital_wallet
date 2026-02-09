// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/domain/entities/token_balance_entity.dart';

part 'token_balance_object.freezed.dart';
part 'token_balance_object.g.dart';

@freezed
abstract class TokenBalanceObject with _$TokenBalanceObject {
  const TokenBalanceObject._();

  @JsonSerializable(includeIfNull: false)
  const factory TokenBalanceObject({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'changes') double? changes,
    @JsonKey(name: 'post_balance') String? postBalance,
  }) = _TokenBalanceObject;

  factory TokenBalanceObject.fromJson(Map<String, dynamic> json) =>
      _$TokenBalanceObjectFromJson(json);

  TokenBalanceEntity toEntity() => TokenBalanceEntity(
    address: address,
    token: token,
    changes: changes,
    postBalance: postBalance,
  );
}
