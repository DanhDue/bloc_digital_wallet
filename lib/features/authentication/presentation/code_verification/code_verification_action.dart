// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class CodeVerificationAction extends BaseAction {
  const CodeVerificationAction();
}

class VerifyCodeAction extends CodeVerificationAction {
  final String code;
  const VerifyCodeAction(this.code);
}
