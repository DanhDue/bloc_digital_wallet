// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;

  const AuthUserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    firstName,
    lastName,
    phoneNumber,
    dateOfBirth,
  ];
}
