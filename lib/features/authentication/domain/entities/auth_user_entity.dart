// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;

  const AuthUserEntity({required this.id, required this.email, this.displayName});

  @override
  List<Object?> get props => [id, email, displayName];
}
