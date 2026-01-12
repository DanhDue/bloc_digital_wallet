// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class RegisterEvent extends BaseEvent {
  const RegisterEvent();
}

class ShowRegisterSuccessMessage extends RegisterEvent {
  final String message;
  const ShowRegisterSuccessMessage(this.message);
}

class ShowRegisterErrorMessage extends RegisterEvent {
  final String message;
  const ShowRegisterErrorMessage(this.message);
}
