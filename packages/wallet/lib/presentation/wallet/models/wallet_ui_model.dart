// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

part 'wallet_ui_model.freezed.dart';

@freezed
abstract class WalletUiModel with _$WalletUiModel {
  const factory WalletUiModel({required String id, required String name, String? description}) =
      _WalletUiModel;

  factory WalletUiModel.fromEntity(WalletEntity entity) {
    return WalletUiModel(id: entity.id, name: entity.name, description: entity.description);
  }
}
