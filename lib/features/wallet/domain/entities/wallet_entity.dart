// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_entity.freezed.dart';

/// ============================================================================
/// Wallet Entity
/// ============================================================================
/// Entities are pure Dart classes representing business objects.
/// They should NOT have any Flutter or external dependencies.
///
/// Refactored to use Freezed for immutability and copyWith support.
/// ============================================================================

@freezed
abstract class WalletEntity with _$WalletEntity {
  const WalletEntity._();

  const factory WalletEntity({
    @Default(false) bool isValid,
    @Default('') String privateKey,
    @Default('') String bs58PrivateKey,
    @Default('') String address,
    @Default(0.0) double balance,
    @Default(0.0) double dailyChange,
  }) = _WalletEntity;
}
