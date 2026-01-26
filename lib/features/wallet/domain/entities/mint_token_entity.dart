// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:equatable/equatable.dart';

class MintTokenEntity extends Equatable {
  final String? address;
  final String? symbol;
  final String? name;
  final int? decimals;
  final String? logo;
  final String? coingeckoId;
  final String? status;
  final bool? isVerified;

  const MintTokenEntity({
    this.address,
    this.symbol,
    this.name,
    this.decimals,
    this.logo,
    this.coingeckoId,
    this.status,
    this.isVerified,
  });

  @override
  List<Object?> get props => [
    address,
    symbol,
    name,
    decimals,
    logo,
    coingeckoId,
    status,
    isVerified,
  ];
}
