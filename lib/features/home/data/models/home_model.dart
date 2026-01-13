// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_entity.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

@freezed
sealed class HomeModel with _$HomeModel {
  const HomeModel._();

  const factory HomeModel({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);

  /// Convert model to entity
  HomeEntity toEntity() {
    return HomeEntity(id: id, name: name);
  }

  /// Create model from entity
  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(id: entity.id, name: entity.name);
  }
}
