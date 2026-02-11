// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';

class StringOrNumConverter implements JsonConverter<String?, Object?> {
  const StringOrNumConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is num) return json.toString();
    return json.toString();
  }

  @override
  Object? toJson(String? object) => object;
}
