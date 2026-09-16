// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

part 'transaction_event.freezed.dart';

@freezed
class TransactionEvent extends BaseEvent with _$TransactionEvent {
  const TransactionEvent._();
  const factory TransactionEvent.navigateToDetail(TransactionEntity transaction) =
      _NavigateToDetail;
  const factory TransactionEvent.showError(String message) = _ShowError;
}
