// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'balance') double? balance,
    @JsonKey(name: 'daily_change') double? dailyChange,
    @JsonKey(name: 'isValid') @Default(true) bool isValid,
    @JsonKey(name: 'privateKey') String? privateKey,
    @JsonKey(name: 'bs58PrivateKey') String? bs58PrivateKey,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);
}

extension WalletModelX on WalletModel {
  WalletEntity toEntity() {
    return WalletEntity(
      id: id ?? address ?? '',
      name: name ?? 'Unknown Wallet',
      description: description,
      address: address,
      balance: balance,
      dailyChange: dailyChange,
      isValid: isValid,
      privateKey: privateKey,
      bs58PrivateKey: bs58PrivateKey,
    );
  }
}
