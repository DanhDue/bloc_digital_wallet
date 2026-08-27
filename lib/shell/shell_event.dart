// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';

part 'shell_event.freezed.dart';

@freezed
class ShellEvent extends BaseEvent with _$ShellEvent {
  const ShellEvent._();
  const factory ShellEvent.showExitToast() = _ShowExitToast;
  const factory ShellEvent.exitApp() = _ExitApp;
}
