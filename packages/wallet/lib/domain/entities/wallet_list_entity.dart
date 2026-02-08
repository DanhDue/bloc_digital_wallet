// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_list_entity.freezed.dart';
part 'wallet_list_entity.g.dart';

@freezed
abstract class WalletListEntity with _$WalletListEntity {
  const factory WalletListEntity({@JsonKey(name: 'id') required String id}) = _WalletListEntity;

  const WalletListEntity._();

  factory WalletListEntity.fromJson(Map<String, dynamic> json) => _$WalletListEntityFromJson(json);
}
