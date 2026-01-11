// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class AuthenticationEvent extends BaseEvent {
  const AuthenticationEvent();
}

class ShowAuthSuccessMessage extends AuthenticationEvent {
  final String message;

  const ShowAuthSuccessMessage(this.message);
}

class ShowAuthErrorMessage extends AuthenticationEvent {
  final String message;

  const ShowAuthErrorMessage(this.message);
}
