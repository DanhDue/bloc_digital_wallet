// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/network_selection_entity.dart';

part 'network_selection_ui_model.freezed.dart';

@freezed
abstract class NetworkSelectionUiModel with _$NetworkSelectionUiModel {
  const factory NetworkSelectionUiModel({
    @Default([]) List<NetworkSelectionEntity> networks,
    @Default('') String searchQuery,
  }) = _NetworkSelectionUiModel;
}
