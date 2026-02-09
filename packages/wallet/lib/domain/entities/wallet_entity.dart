// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_entity.freezed.dart';
part 'wallet_entity.g.dart';

@freezed
abstract class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    required String id,
    required String name,
    String? description,
    String? address,
    double? balance,
    double? dailyChange,
    @Default(true) bool isValid,
    String? privateKey,
    String? bs58PrivateKey,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, dynamic> json) => _$WalletEntityFromJson(json);
}
