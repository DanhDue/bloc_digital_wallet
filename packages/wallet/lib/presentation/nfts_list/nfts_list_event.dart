// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfts_list_event.freezed.dart';

@freezed
abstract class NftsListEvent extends BaseEvent with _$NftsListEvent {
  const factory NftsListEvent.initial() = _Initial;

  const NftsListEvent._();
}
