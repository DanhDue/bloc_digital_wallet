// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_token_object.freezed.dart';
part 'mint_token_object.g.dart';

@freezed
abstract class MintTokenObject with _$MintTokenObject {
  @JsonSerializable(includeIfNull: false)
  const factory MintTokenObject({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'decimals') int? decimals,
    @JsonKey(name: 'supply') int? supply,
    @JsonKey(name: 'is_initialized') int? isInitialized,
    @JsonKey(name: 'mint_authority') String? mintAuthority,
    @JsonKey(name: 'update_authority') String? updateAuthority,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'symbol') String? symbol,
    @JsonKey(name: 'uri') String? uri,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'is_mutable') bool? isMutable,
  }) = _MintTokenObject;

  factory MintTokenObject.fromJson(Map<String, Object?> json) => _$MintTokenObjectFromJson(json);
}
