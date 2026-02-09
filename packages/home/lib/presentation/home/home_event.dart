// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

@freezed
abstract class HomeEvent extends BaseEvent with _$HomeEvent {
  const factory HomeEvent.initial() = _Initial;
  const HomeEvent._() : super();
}
