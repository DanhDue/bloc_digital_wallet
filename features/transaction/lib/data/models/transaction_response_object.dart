// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/data/models/account_input_object.dart';
import 'package:transaction/data/models/token_balance_object.dart';
import 'package:transaction/data/models/transaction_overview_object.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

part 'transaction_response_object.freezed.dart';
part 'transaction_response_object.g.dart';

@freezed
abstract class TransactionResponseObject with _$TransactionResponseObject {
  const TransactionResponseObject._();

  @JsonSerializable(includeIfNull: false)
  const factory TransactionResponseObject({
    @JsonKey(name: 'isLabel') bool? isLabel,
    @JsonKey(name: 'isLast') bool? isLast,
    @JsonKey(name: 'signature') String? signature,
    @JsonKey(name: 'overview') TransactionOverviewObject? overview,
    @JsonKey(name: 'account_inputs') List<AccountInputObject>? accountInputs,
    @JsonKey(name: 'token_balances') List<TokenBalanceObject>? tokenBalances,
    @JsonKey(name: 'transaction_type') String? transactionType,
  }) = _TransactionResponseObject;

  factory TransactionResponseObject.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseObjectFromJson(json);

  TransactionEntity toEntity() => TransactionEntity(
    isLabel: isLabel,
    signature: signature,
    overview: overview?.toEntity(),
    accountInputs: accountInputs?.map((e) => e.toEntity()).toList(),
    tokenBalances: tokenBalances?.map((e) => e.toEntity()).toList(),
    transactionType: transactionType,
  );
}
