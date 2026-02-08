// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/presentation/transaction/models/transaction_ui_model.dart';

part 'transaction_state.freezed.dart';

enum TransactionStatus { initial, loading, success, failure }

@freezed
abstract class TransactionState extends BaseState with _$TransactionState {
  const factory TransactionState({
    @Default(TransactionStatus.initial) TransactionStatus status,
    TransactionUiModel? uiModel,
    String? errorMessage,
  }) = _TransactionState;

  const TransactionState._() : super();
}
