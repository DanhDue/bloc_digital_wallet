// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jiffy/jiffy.dart';

class JiffyLongJsonConverter implements JsonConverter<Jiffy?, int?> {
  const JiffyLongJsonConverter();

  @override
  Jiffy? fromJson(int? json) {
    if (json == null) return null;
    return Jiffy.parseFromMillisecondsSinceEpoch(json);
  }

  @override
  int? toJson(Jiffy? object) {
    return object?.millisecondsSinceEpoch;
  }
}
