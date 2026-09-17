// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

part 'transaction_action.freezed.dart';

@freezed
class TransactionAction extends BaseAction with _$TransactionAction {
  const TransactionAction._();
  const factory TransactionAction.started() = _Started;
  const factory TransactionAction.refresh() = _Refresh;
  const factory TransactionAction.loadMore() = _LoadMore;
  const factory TransactionAction.filterChanged(int index) = _FilterChanged;
  const factory TransactionAction.openTransactionDetail(TransactionEntity transaction) =
      _OpenTransactionDetail;
}
