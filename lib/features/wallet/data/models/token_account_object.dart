// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:bloc_digital_wallet/features/wallet/data/models/mint_token_object.dart';

part 'token_account_object.freezed.dart';
part 'token_account_object.g.dart';

@freezed
abstract class TokenAccountObject with _$TokenAccountObject {
  @JsonSerializable(includeIfNull: false)
  const factory TokenAccountObject({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'mint_token') MintTokenObject? mintToken,
    @JsonKey(name: 'account_owner') String? accountOwner,
  }) = _TokenAccountObject;

  factory TokenAccountObject.fromJson(Map<String, Object?> json) =>
      _$TokenAccountObjectFromJson(json);
}
