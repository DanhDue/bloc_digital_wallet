// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/token_list_entity.dart';

import 'mint_token_model.dart';

part 'token_list_model.freezed.dart';
part 'token_list_model.g.dart';

@freezed
abstract class TokenListModel with _$TokenListModel {
  const factory TokenListModel({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'mint_token') MintTokenModel? mintToken,
    @JsonKey(name: 'account_owner') String? accountOwner,
  }) = _TokenListModel;

  const TokenListModel._();

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
