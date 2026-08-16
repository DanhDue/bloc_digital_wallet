// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/token_list_entity.dart';

part 'token_list_ui_model.freezed.dart';

@freezed
abstract class TokenListUiModel with _$TokenListUiModel {
  const TokenListUiModel._();

  const factory TokenListUiModel({
    required String id,
    required String name,
    required String symbol,
    required String imageUrl,
    required String formattedBalance,
    required String formattedFiatBalance,
    required String formattedPercentChange,
    required bool isPositiveChange,
  }) = _TokenListUiModel;

  factory TokenListUiModel.fromEntity(TokenListEntity entity) {
    // Generate random trend data for demo purposes
    final random = Random(entity.id.hashCode);
    final isPositive = random.nextBool();
    final percentChange = (random.nextDouble() * 14.9) + 0.1;

    final balance = entity.balance ?? 0.0;
    return TokenListUiModel(
      id: entity.id,
      name: entity.name ?? '',
      symbol: entity.symbol ?? '',
      imageUrl: entity.logo ?? '',
      formattedBalance: '${balance.toStringAsFixed(2)} ${entity.symbol ?? ""}',
      formattedFiatBalance: '\$${balance.toStringAsFixed(2)}',
      formattedPercentChange: '${isPositive ? "+" : "-"}${percentChange.toStringAsFixed(2)}%',
      isPositiveChange: isPositive,
    );
  }
}
