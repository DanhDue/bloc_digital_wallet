// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class ForgotPasswordAction extends BaseAction {
  const ForgotPasswordAction();
}

class SendResetLinkAction extends ForgotPasswordAction {
  final String email;
  const SendResetLinkAction(this.email);
}
