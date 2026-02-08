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
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

extension WalletModelX on WalletModel {
  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      name: name,
      description: description,
    );
  }
}
