// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jiffy/jiffy.dart';

part 'transaction_overview_entity.freezed.dart';

@freezed
abstract class TransactionOverviewEntity with _$TransactionOverviewEntity {
  const TransactionOverviewEntity._();

  const factory TransactionOverviewEntity({
    List<String>? signature,
    String? result,
    Jiffy? timestamp,
    String? confirmationStatus,
    String? confirmations,
    int? slot,
    String? recentBlockhash,
    double? fee,
    int? computeUnitsConsumed,
    double? transactionCost,
    int? reservedCus,
    String? transactionVersion,
    String? payerAddress,
  }) = _TransactionOverviewEntity;
}
