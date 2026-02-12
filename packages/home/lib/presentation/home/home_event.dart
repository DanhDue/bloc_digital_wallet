// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent extends BaseEvent with _$HomeEvent {
  const HomeEvent._();
  const factory HomeEvent.showExitToast() = _ShowExitToast;
  const factory HomeEvent.exitApp() = _ExitApp;
}
