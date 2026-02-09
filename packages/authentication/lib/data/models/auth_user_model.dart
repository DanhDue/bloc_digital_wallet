// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
abstract class AuthUserModel with _$AuthUserModel {
  const AuthUserModel._();

  @JsonSerializable(includeIfNull: false)
  const factory AuthUserModel({
    @JsonKey(name: 'refresh') String? refresh,
    @JsonKey(name: 'access') String? access,
    @JsonKey(name: 'user') AuthUserInnerModel? user,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => _$AuthUserModelFromJson(json);
}

@freezed
abstract class AuthUserInnerModel with _$AuthUserInnerModel {
  const AuthUserInnerModel._();

  @JsonSerializable(includeIfNull: false)
  const factory AuthUserInnerModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'email') String? email,
  }) = _AuthUserInnerModel;

  factory AuthUserInnerModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserInnerModelFromJson(json);
}
