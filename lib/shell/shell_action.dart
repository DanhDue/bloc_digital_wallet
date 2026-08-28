// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';

part 'shell_action.freezed.dart';

@freezed
class ShellAction extends BaseAction with _$ShellAction {
  const ShellAction._();
  const factory ShellAction.started() = _Started;
  const factory ShellAction.tabChanged(int index) = _TabChanged;
  const factory ShellAction.tabDoubleTapped(int index) = _TabDoubleTapped;
  const factory ShellAction.backPressed() = _BackPressed;
}
