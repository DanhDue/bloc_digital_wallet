// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_entity.freezed.dart';
part 'wallet_entity.g.dart';

@freezed
abstract class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, dynamic> json) =>
      _$WalletEntityFromJson(json);
}
