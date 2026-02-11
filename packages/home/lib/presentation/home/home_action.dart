// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';

part 'home_action.freezed.dart';

@freezed
class HomeAction extends BaseAction with _$HomeAction {
  const HomeAction._();
  const factory HomeAction.started() = _Started;
  const factory HomeAction.tabChanged(int index) = _TabChanged;
  const factory HomeAction.tabDoubleTapped(int index) = _TabDoubleTapped;
  const factory HomeAction.backPressed() = _BackPressed;
}
