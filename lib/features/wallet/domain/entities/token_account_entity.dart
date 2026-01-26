// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';
import 'mint_token_entity.dart';

class TokenAccountEntity extends Equatable {
  final String? address;
  final String? owner;
  final double? amount;
  final MintTokenEntity? mintToken;
  final String? accountOwner;

  const TokenAccountEntity({
    this.address,
    this.owner,
    this.amount,
    this.mintToken,
    this.accountOwner,
  });

  @override
  List<Object?> get props => [address, owner, amount, mintToken, accountOwner];
}
