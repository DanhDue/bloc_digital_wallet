// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class RegisterAction extends BaseAction {
  const RegisterAction();
}

class RegisterWithEmailAction extends RegisterAction {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime dateOfBirth;

  const RegisterWithEmailAction({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateOfBirth,
  });
}
