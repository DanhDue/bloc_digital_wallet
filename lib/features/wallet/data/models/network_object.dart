// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_object.freezed.dart';
part 'network_object.g.dart';

@freezed
abstract class NetworkObject with _$NetworkObject {
  @JsonSerializable(includeIfNull: false)
  const factory NetworkObject({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'name') String? name,
  }) = _NetworkObject;

  factory NetworkObject.fromJson(Map<String, Object?> json) => _$NetworkObjectFromJson(json);
}
