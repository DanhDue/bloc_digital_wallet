// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/nfts_list_entity.dart';

part 'nfts_list_model.freezed.dart';
part 'nfts_list_model.g.dart';

@freezed
abstract class NftsListModel with _$NftsListModel {
  const NftsListModel._();

  @JsonSerializable(includeIfNull: false)
  const factory NftsListModel({@JsonKey(name: 'id') required String id}) = _NftsListModel;

  factory NftsListModel.fromJson(Map<String, dynamic> json) => _$NftsListModelFromJson(json);

  NftsListEntity toEntity() {
    return NftsListEntity(id: id);
  }
}
