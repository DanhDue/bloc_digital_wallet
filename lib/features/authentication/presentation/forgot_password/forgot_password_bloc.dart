// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import 'forgot_password_action.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordBloc
    extends MviBloc<ForgotPasswordAction, ForgotPasswordState, ForgotPasswordEvent> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordBloc(this._forgotPasswordUseCase) : super(const ForgotPasswordInitial()) {
    handleActionDroppable<SendResetLinkAction>(_onSendResetLink);
  }

  @override
  void onAction(ForgotPasswordAction action) {
    add(action);
  }

  Future<void> _onSendResetLink(
    SendResetLinkAction action,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordLoading());

    final result = await _forgotPasswordUseCase(action.email);

    result.fold(
      (failure) {
        emit(ForgotPasswordError(failure.message));
        emitEvent(ShowForgotPasswordErrorMessage(failure.message));
      },
      (_) {
        emit(const ForgotPasswordSuccess());
        emitEvent(const ShowForgotPasswordSuccessMessage('Reset link sent to email'));
        emitEvent(const NavigateToCodeVerification());
      },
    );
  }
}
