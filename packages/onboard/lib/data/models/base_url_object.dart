// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_url_object.freezed.dart';
part 'base_url_object.g.dart';

@freezed
abstract class BaseUrlObject with _$BaseUrlObject {
  const factory BaseUrlObject({
    @JsonKey(name: 'app_id') String? appId,
    @JsonKey(name: 'base_url') String? baseUrl,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _BaseUrlObject;

  factory BaseUrlObject.fromJson(Map<String, dynamic> json) => _$BaseUrlObjectFromJson(json);
}
