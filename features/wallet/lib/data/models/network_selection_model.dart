// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/network_selection_entity.dart';

part 'network_selection_model.freezed.dart';
part 'network_selection_model.g.dart';

@freezed
abstract class NetworkSelectionModel with _$NetworkSelectionModel {
  const NetworkSelectionModel._();

  @JsonSerializable(includeIfNull: false)
  const factory NetworkSelectionModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'logo') String? logo,
  }) = _NetworkSelectionModel;

  factory NetworkSelectionModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkSelectionModelFromJson(json);

  NetworkSelectionEntity toEntity() {
    return NetworkSelectionEntity(id: id, name: name, logo: logo);
  }
}
