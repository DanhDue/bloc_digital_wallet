// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';

sealed class CodeVerificationState extends BaseState with EquatableMixin {
  const CodeVerificationState();

  @override
  List<Object?> get props => [];
}

class CodeVerificationInitial extends CodeVerificationState {
  const CodeVerificationInitial();
}

class CodeVerificationLoading extends CodeVerificationState {
  const CodeVerificationLoading();
}

class CodeVerificationSuccess extends CodeVerificationState {
  const CodeVerificationSuccess();
}

class CodeVerificationError extends CodeVerificationState {
  final String message;
  const CodeVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
