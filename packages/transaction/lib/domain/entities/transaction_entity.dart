// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/domain/entities/account_input_entity.dart';
import 'package:transaction/domain/entities/token_balance_entity.dart';
import 'package:transaction/domain/entities/transaction_overview_entity.dart';

part 'transaction_entity.freezed.dart';

@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const TransactionEntity._();

  const factory TransactionEntity({
    bool? isLabel,
    String? signature,
    TransactionOverviewEntity? overview,
    List<AccountInputEntity>? accountInputs,
    List<TokenBalanceEntity>? tokenBalances,
    String? transactionType,
  }) = _TransactionEntity;
}
