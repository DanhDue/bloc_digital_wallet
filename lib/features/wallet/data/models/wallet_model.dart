// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wallet_entity.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const WalletModel._();

  @JsonSerializable(includeIfNull: false)
  const factory WalletModel({
    @JsonKey(name: 'isValid') @Default(false) bool? isValid,
    @JsonKey(name: 'privateKey') String? privateKey,
    @JsonKey(name: 'bs58PrivateKey') String? bs58PrivateKey,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'balance') @Default(0.0) double? balance,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, Object?> json) => _$WalletModelFromJson(json);

  /// Convert to domain entity
  WalletEntity toEntity() => WalletEntity(
    isValid: isValid ?? false,
    privateKey: privateKey ?? '',
    bs58PrivateKey: bs58PrivateKey ?? '',
    address: address ?? '',
    balance: balance ?? 0.0,
  );

  /// Create from domain entity
  factory WalletModel.fromEntity(WalletEntity entity) => WalletModel(
    isValid: entity.isValid,
    privateKey: entity.privateKey,
    bs58PrivateKey: entity.bs58PrivateKey,
    address: entity.address,
    balance: entity.balance,
  );
}
