// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_event.freezed.dart';

@freezed
abstract class TransactionEvent extends BaseEvent with _$TransactionEvent {
  const factory TransactionEvent.initial() = _Initial;
  const TransactionEvent._() : super();
}
