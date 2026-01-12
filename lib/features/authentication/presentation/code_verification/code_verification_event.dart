// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class CodeVerificationEvent extends BaseEvent {
  const CodeVerificationEvent();
}

class ShowCodeVerificationSuccessMessage extends CodeVerificationEvent {
  final String message;
  const ShowCodeVerificationSuccessMessage(this.message);
}

class ShowCodeVerificationErrorMessage extends CodeVerificationEvent {
  final String message;
  const ShowCodeVerificationErrorMessage(this.message);
}

class NavigateToSetNewPassword extends CodeVerificationEvent {
  const NavigateToSetNewPassword();
}
