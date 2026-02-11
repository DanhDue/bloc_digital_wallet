// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState extends BaseState with _$HomeState {
  const HomeState._();
  const factory HomeState({@Default(0) int currentTabIndex}) = _HomeState;
}
