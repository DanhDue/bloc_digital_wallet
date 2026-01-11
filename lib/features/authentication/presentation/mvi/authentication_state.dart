// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/auth_user_entity.dart';

sealed class AuthenticationState extends BaseState with EquatableMixin {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();

  @override
  List<Object?> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final AuthUserEntity user;

  const AuthenticationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError(this.message);

  @override
  List<Object?> get props => [message];
}
