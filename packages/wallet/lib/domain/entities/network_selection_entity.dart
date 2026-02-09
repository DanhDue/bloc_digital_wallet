// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_selection_entity.freezed.dart';

@freezed
abstract class NetworkSelectionEntity with _$NetworkSelectionEntity {
  const NetworkSelectionEntity._();

  const factory NetworkSelectionEntity({String? id, String? name, String? logo}) =
      _NetworkSelectionEntity;
}
