// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mint_token.dart';

part 'token_account_object.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TokenAccountObject extends Equatable {
  final String? address;
  final String? owner;
  final double? amount;
  final MintToken? mintToken;
  final String? accountOwner;

  const TokenAccountObject({
    this.address,
    this.owner,
    this.amount,
    this.mintToken,
    this.accountOwner,
  });

  factory TokenAccountObject.fromJson(Map<String, dynamic> json) =>
      _$TokenAccountObjectFromJson(json);

  Map<String, dynamic> toJson() => _$TokenAccountObjectToJson(this);

  @override
  List<Object?> get props => [address, owner, amount, mintToken, accountOwner];
}
