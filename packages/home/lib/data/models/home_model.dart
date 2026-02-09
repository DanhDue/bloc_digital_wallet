// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home/domain/entities/home_entity.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

@freezed
abstract class HomeModel with _$HomeModel {
  const HomeModel._();

  @JsonSerializable(includeIfNull: false)
  const factory HomeModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
  }) = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);

  HomeEntity toEntity() => HomeEntity(id: id, name: name);
}
