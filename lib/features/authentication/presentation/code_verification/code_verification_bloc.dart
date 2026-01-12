// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/verify_code_usecase.dart';
import 'code_verification_action.dart';
import 'code_verification_event.dart';
import 'code_verification_state.dart';

@injectable
class CodeVerificationBloc
    extends MviBloc<CodeVerificationAction, CodeVerificationState, CodeVerificationEvent> {
  final VerifyCodeUseCase _verifyCodeUseCase;

  CodeVerificationBloc(this._verifyCodeUseCase) : super(const CodeVerificationInitial()) {
    handleActionDroppable<VerifyCodeAction>(_onVerifyCode);
  }

  @override
  void onAction(CodeVerificationAction action) {
    add(action);
  }

  Future<void> _onVerifyCode(VerifyCodeAction action, Emitter<CodeVerificationState> emit) async {
    emit(const CodeVerificationLoading());

    final result = await _verifyCodeUseCase(action.code);

    result.fold(
      (failure) {
        emit(CodeVerificationError(failure.message));
        emitEvent(ShowCodeVerificationErrorMessage(failure.message));
      },
      (_) {
        emit(const CodeVerificationSuccess());
        emitEvent(const ShowCodeVerificationSuccessMessage('Code verified successfully'));
        emitEvent(const NavigateToSetNewPassword());
      },
    );
  }
}
