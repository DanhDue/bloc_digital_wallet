// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_selection_event.freezed.dart';

@freezed
abstract class NetworkSelectionEvent extends BaseEvent with _$NetworkSelectionEvent {
  const factory NetworkSelectionEvent.initial() = _Initial;

  const NetworkSelectionEvent._();
}
