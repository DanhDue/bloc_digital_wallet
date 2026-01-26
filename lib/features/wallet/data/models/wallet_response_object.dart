// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wallet_entity.dart';

part 'wallet_response_object.freezed.dart';
part 'wallet_response_object.g.dart';

@freezed
abstract class WalletResponseObject with _$WalletResponseObject {
  @JsonSerializable(includeIfNull: false)
  const factory WalletResponseObject({
    @JsonKey(name: 'isValid') bool? isValid,
    @JsonKey(name: 'privateKey') String? privateKey,
    @JsonKey(name: 'bs58PrivateKey') String? bs58PrivateKey,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'balance') num? balance,
  }) = _WalletResponseObject;

  factory WalletResponseObject.fromJson(Map<String, Object?> json) =>
      _$WalletResponseObjectFromJson(json);

  WalletEntity toEntity() => WalletEntity(
    isValid: isValid ?? false,
    privateKey: privateKey ?? '',
    bs58PrivateKey: bs58PrivateKey ?? '',
    address: address ?? '',
    balance: (balance ?? 0).toDouble(),
  );
}
