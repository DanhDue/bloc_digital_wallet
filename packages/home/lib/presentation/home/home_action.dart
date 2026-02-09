// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_action.freezed.dart';

@freezed
abstract class HomeAction extends BaseAction with _$HomeAction {
  const factory HomeAction.started() = _Started;
  const HomeAction._() : super();
}
