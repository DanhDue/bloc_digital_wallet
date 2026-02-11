// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

part 'transaction_list_item.freezed.dart';

@freezed
abstract class TransactionListItem with _$TransactionListItem {
  const factory TransactionListItem.header(String title) = _Header;
  const factory TransactionListItem.transaction(
    TransactionEntity transaction, {
    @Default(false) bool isLast,
    @Default(false) bool isReceived,
    @Default('') String formattedTime,
    @Default('') String formattedAmount,
    @Default('') String formattedFiatAmount,
  }) = _Transaction;
}
