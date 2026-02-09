// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

part 'wallet_list_entity.freezed.dart';

@freezed
abstract class WalletListEntity with _$WalletListEntity {
  const WalletListEntity._();

  const factory WalletListEntity({required String id, @Default([]) List<WalletEntity> wallets}) =
      _WalletListEntity;
}
