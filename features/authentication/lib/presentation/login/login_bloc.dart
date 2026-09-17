// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:framework/framework.dart';
import '../../domain/usecases/login_with_email_password_usecase.dart';
import 'login_action.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginBloc extends MviBloc<LoginAction, LoginState, LoginEvent> {
  final LoginWithEmailPasswordUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginInitial()) {
    handleActionDroppable<LoginWithEmailPasswordAction>(_onLoginWithEmailPassword);
  }

  @override
  void onAction(LoginAction action) {
    add(action);
  }

  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPasswordAction action,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await _loginUseCase(email: action.email, password: action.password);

    result.fold(
      (failure) {
        emit(LoginError(failure.message));
        emitEvent(ShowLoginErrorMessage(failure.message));
      },
      (user) {
        emit(LoginSuccess(user));
        emitEvent(ShowLoginSuccessMessage('Logged in as ${user.email}'));
        // Navigate to home after successful login
        emitEvent(const NavigateToHome());
      },
    );
  }
}
