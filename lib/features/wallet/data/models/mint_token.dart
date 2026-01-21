// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mint_token.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MintToken extends Equatable {
  final String? address;
  final int? decimals;
  final num? supply;
  final int? isInitialized;
  final String? mintAuthority;
  final String? updateAuthority;
  final String? name;
  final String? symbol;
  final String? uri;
  final String? logo;
  final bool? isMutable;

  const MintToken({
    this.address,
    this.decimals,
    this.supply,
    this.isInitialized,
    this.mintAuthority,
    this.updateAuthority,
    this.name,
    this.symbol,
    this.uri,
    this.logo,
    this.isMutable,
  });

  factory MintToken.fromJson(Map<String, dynamic> json) => _$MintTokenFromJson(json);

  Map<String, dynamic> toJson() => _$MintTokenToJson(this);

  @override
  List<Object?> get props => [
        address,
        decimals,
        supply,
        isInitialized,
        mintAuthority,
        updateAuthority,
        name,
        symbol,
        uri,
        logo,
        isMutable,
      ];
}
