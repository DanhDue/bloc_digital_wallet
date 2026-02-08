// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_action.freezed.dart';

@freezed
abstract class TrendsAction extends BaseAction with _$TrendsAction {
  const factory TrendsAction.started() = _Started;
  const TrendsAction._() : super();
}
