// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_event.freezed.dart';

@freezed
abstract class TrendsEvent extends BaseEvent with _$TrendsEvent {
  const factory TrendsEvent.initial() = _Initial;
  const TrendsEvent._() : super();
}
