// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/token_list_entity.dart';

part 'token_list_model.freezed.dart';
part 'token_list_model.g.dart';

@freezed
abstract class TokenListModel with _$TokenListModel {
  const factory TokenListModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'symbol') String? symbol,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'balance') double? balance,
  }) = _TokenListModel;

  const TokenListModel._();

  factory TokenListModel.fromJson(Map<String, dynamic> json) => _$TokenListModelFromJson(json);

  TokenListEntity toEntity() {
    return TokenListEntity(id: id, name: name, symbol: symbol, logo: logo, balance: balance);
  }
}
