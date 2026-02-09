// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_entity.freezed.dart';

@freezed
abstract class HomeEntity with _$HomeEntity {
  const HomeEntity._();

  const factory HomeEntity({required String id, required String name}) = _HomeEntity;
}
