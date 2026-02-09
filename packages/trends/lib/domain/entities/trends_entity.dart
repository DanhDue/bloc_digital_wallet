// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_entity.freezed.dart';

@freezed
abstract class TrendsEntity with _$TrendsEntity {
  const TrendsEntity._();

  const factory TrendsEntity({required String id, required String name, String? description}) =
      _TrendsEntity;
}
