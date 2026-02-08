// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfts_list_entity.freezed.dart';
part 'nfts_list_entity.g.dart';

@freezed
abstract class NftsListEntity with _$NftsListEntity {
  const factory NftsListEntity({@JsonKey(name: 'id') required String id}) = _NftsListEntity;

  const NftsListEntity._();

  factory NftsListEntity.fromJson(Map<String, dynamic> json) => _$NftsListEntityFromJson(json);
}
