// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class ForgotPasswordEvent extends BaseEvent {
  const ForgotPasswordEvent();
}

class ShowForgotPasswordSuccessMessage extends ForgotPasswordEvent {
  final String message;
  const ShowForgotPasswordSuccessMessage(this.message);
}

class ShowForgotPasswordErrorMessage extends ForgotPasswordEvent {
  final String message;
  const ShowForgotPasswordErrorMessage(this.message);
}

/// Navigate to Code Verification
class NavigateToCodeVerification extends ForgotPasswordEvent {
  const NavigateToCodeVerification();
}
