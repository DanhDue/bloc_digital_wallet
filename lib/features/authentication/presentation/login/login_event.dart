// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class LoginEvent extends BaseEvent {
  const LoginEvent();
}

class ShowLoginSuccessMessage extends LoginEvent {
  final String message;
  const ShowLoginSuccessMessage(this.message);
}

class ShowLoginErrorMessage extends LoginEvent {
  final String message;
  const ShowLoginErrorMessage(this.message);
}
