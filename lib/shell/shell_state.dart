// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';
import 'package:d3_nexus_shield/shell/shell_config.dart';

part 'shell_state.freezed.dart';

@freezed
abstract class ShellState extends BaseState with _$ShellState {
  const ShellState._();
  const factory ShellState({
    @Default(ShellConfig.defaultTabIndex) int currentTabIndex,
  }) = _ShellState;
}
