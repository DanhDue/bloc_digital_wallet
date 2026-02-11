// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';
import 'package:transaction/presentation/transaction/ui_models/transaction_list_item.dart';

part 'transaction_state.freezed.dart';

@freezed
abstract class TransactionState extends BaseState with _$TransactionState {
  const TransactionState._();
  const factory TransactionState({
    @Default(false) bool isLoading,
    @Default([]) List<TransactionListItem> items,
    @Default(0) int filterIndex,
    String? error,
    @Default(false) bool hasReachedMax,
  }) = _TransactionState;
}
