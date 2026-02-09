// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/utils/jiffy_long_json_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:transaction/domain/entities/transaction_overview_entity.dart';

part 'transaction_overview_object.freezed.dart';
part 'transaction_overview_object.g.dart';

@freezed
abstract class TransactionOverviewObject with _$TransactionOverviewObject {
  const TransactionOverviewObject._();

  @JsonSerializable(includeIfNull: false)
  const factory TransactionOverviewObject({
    @JsonKey(name: 'signature') List<String>? signature,
    @JsonKey(name: 'result') String? result,
    @JsonKey(name: 'timestamp') @JiffyLongJsonConverter() Jiffy? timestamp,
    @JsonKey(name: 'confirmation_status') String? confirmationStatus,
    @JsonKey(name: 'confirmations') String? confirmations,
    @JsonKey(name: 'slot') int? slot,
    @JsonKey(name: 'recent_blockhash') String? recentBlockhash,
    @JsonKey(name: 'fee') double? fee,
    @JsonKey(name: 'compute_units_consumed') int? computeUnitsConsumed,
    @JsonKey(name: 'transaction_cost') double? transactionCost,
    @JsonKey(name: 'reserved_cus') int? reservedCus,
    @JsonKey(name: 'transaction_version') String? transactionVersion,
    @JsonKey(name: 'payer_address') String? payerAddress,
  }) = _TransactionOverviewObject;

  factory TransactionOverviewObject.fromJson(Map<String, dynamic> json) =>
      _$TransactionOverviewObjectFromJson(json);

  TransactionOverviewEntity toEntity() => TransactionOverviewEntity(
    signature: signature,
    result: result,
    timestamp: timestamp,
    confirmationStatus: confirmationStatus,
    confirmations: confirmations,
    slot: slot,
    recentBlockhash: recentBlockhash,
    fee: fee,
    computeUnitsConsumed: computeUnitsConsumed,
    transactionCost: transactionCost,
    reservedCus: reservedCus,
    transactionVersion: transactionVersion,
    payerAddress: payerAddress,
  );
}
