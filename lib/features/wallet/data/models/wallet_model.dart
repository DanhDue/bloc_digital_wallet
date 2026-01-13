// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wallet_entity.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
sealed class WalletModel with _$WalletModel {
  const WalletModel._();

  const factory WalletModel({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);

  /// Convert model to entity
  WalletEntity toEntity() {
    return WalletEntity(id: id, name: name);
  }

  /// Create model from entity
  factory WalletModel.fromEntity(WalletEntity entity) {
    return WalletModel(id: entity.id, name: entity.name);
  }
}
