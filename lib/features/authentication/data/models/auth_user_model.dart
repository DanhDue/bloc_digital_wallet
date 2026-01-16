// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user_entity.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
abstract class AuthUserModel with _$AuthUserModel {
  const AuthUserModel._();

  const factory AuthUserModel({String? refresh, String? access, AuthUserInnerModel? user}) =
      _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => _$AuthUserModelFromJson(json);

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: user?.id?.toString() ?? '',
      email: user?.email ?? '',
      displayName: user?.username,
      // Mapping other fields if available or leaving them null/default
      firstName: null,
      lastName: null,
      phoneNumber: null,
      dateOfBirth: null,
    );
  }
}

@freezed
abstract class AuthUserInnerModel with _$AuthUserInnerModel {
  const factory AuthUserInnerModel({int? id, String? username, String? email}) =
      _AuthUserInnerModel;

  factory AuthUserInnerModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserInnerModelFromJson(json);
}
