// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Data model for Profile in Settings module
@freezed
sealed class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String name,
    // TODO: Add your model properties
  }) = _ProfileModel;

  const ProfileModel._();

  /// Convert from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  /// Convert to Entity (Domain Layer)
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      // TODO: Map your properties
    );
  }

  /// Create from Entity (Domain Layer)
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      // TODO: Map your properties
    );
  }
}
