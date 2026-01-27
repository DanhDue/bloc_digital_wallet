// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/token_account_entity.dart';

part 'token_ui_model.freezed.dart';

@freezed
abstract class TokenUiModel with _$TokenUiModel {
  const TokenUiModel._();

  const factory TokenUiModel({
    required String id,
    required String name,
    required String symbol,
    required String imageUrl,
    required String formattedBalance,
    required String formattedFiatBalance,
    required String formattedPercentChange,
    required bool isPositiveChange,
  }) = _TokenUiModel;

  factory TokenUiModel.fromEntity(TokenAccountEntity entity) {
    final mintToken = entity.mintToken;
    final balance = entity.amount ?? 0.0;
    final symbol = mintToken?.symbol ?? '';

    // Generate random trend data for demo purposes
    final random = Random(entity.address.hashCode);
    final isPositive = random.nextBool();
    final percentChange = (random.nextDouble() * 14.9) + 0.1;

    return TokenUiModel(
      id: entity.address ?? '', // or entity.mintToken?.address
      name: mintToken?.name ?? '',
      symbol: symbol,
      imageUrl: mintToken?.logo ?? '',
      formattedBalance: '${balance.toStringAsFixed(2)} $symbol',
      formattedFiatBalance:
          '\$${balance.toStringAsFixed(2)}', // Logic from previous view, likely needs price mult in future
      formattedPercentChange: '${isPositive ? "+" : "-"}${percentChange.toStringAsFixed(2)}%',
      isPositiveChange: isPositive,
    );
  }
}
