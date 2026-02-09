// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_action.freezed.dart';

@freezed
abstract class TransactionAction extends BaseAction with _$TransactionAction {
  const factory TransactionAction.started() = _Started;
  const TransactionAction._() : super();
}
