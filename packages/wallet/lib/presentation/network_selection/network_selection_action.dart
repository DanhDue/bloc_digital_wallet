// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_selection_action.freezed.dart';

@freezed
abstract class NetworkSelectionAction extends BaseAction with _$NetworkSelectionAction {
  const factory NetworkSelectionAction.load() = _Load;
  const factory NetworkSelectionAction.search(String query) = _Search;

  const NetworkSelectionAction._();
}
