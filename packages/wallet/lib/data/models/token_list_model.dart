// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/token_list_entity.dart';
import 'package:wallet/data/models/mint_token_model.dart';

part 'token_list_model.freezed.dart';
part 'token_list_model.g.dart';

@freezed
abstract class TokenListModel with _$TokenListModel {
  const TokenListModel._();

  @JsonSerializable(includeIfNull: false)
  const factory TokenListModel({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'mint_token') MintTokenModel? mintToken,
    @JsonKey(name: 'account_owner') String? accountOwner,
  }) = _TokenListModel;

  factory TokenListModel.fromJson(Map<String, dynamic> json) => _$TokenListModelFromJson(json);

  TokenListEntity toEntity() {
    return TokenListEntity(
      id: address ?? '',
      name: mintToken?.name,
      symbol: mintToken?.symbol,
      logo: mintToken?.logo,
      balance: amount,
    );
  }
}
