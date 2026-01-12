// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/login_with_email_password_usecase.dart';
import '../../domain/usecases/register_with_email_usecase.dart';
import 'authentication_action.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends
        MviBloc<
          AuthenticationAction,
          AuthenticationState,
          AuthenticationEvent
        > {
  final LoginWithEmailPasswordUseCase loginWithEmailPasswordUseCase;
  final RegisterWithEmailUseCase registerWithEmailUseCase;

  AuthenticationBloc(
    this.loginWithEmailPasswordUseCase,
    this.registerWithEmailUseCase,
  ) : super(const AuthenticationInitial()) {
    handleActionDroppable<LoginWithEmailPasswordAction>(
      _onLoginWithEmailPassword,
    );
    handleActionDroppable<RegisterWithEmailAction>(_onRegisterWithEmail);
  }

  @override
  void onAction(AuthenticationAction action) {
    add(action);
  }

  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPasswordAction action,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationLoading());

    final result = await loginWithEmailPasswordUseCase(
      email: action.email,
      password: action.password,
    );

    result.fold(
      (failure) {
        emit(AuthenticationError(failure.message));
        emitEvent(ShowAuthErrorMessage(failure.message));
      },
      (user) {
        emit(AuthenticationSuccess(user));
        emitEvent(ShowAuthSuccessMessage('Logged in as ${user.email}'));
      },
    );
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailAction action,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationLoading());

    final result = await registerWithEmailUseCase(
      email: action.email,
      password: action.password,
      firstName: action.firstName,
      lastName: action.lastName,
      phoneNumber: action.phoneNumber,
      dateOfBirth: action.dateOfBirth,
    );

    result.fold(
      (failure) {
        emit(AuthenticationError(failure.message));
        emitEvent(ShowAuthErrorMessage(failure.message));
      },
      (user) {
        emit(AuthenticationSuccess(user));
        emitEvent(
          ShowAuthSuccessMessage(
            'Welcome ${user.firstName}! Registration successful.',
          ),
        );
      },
    );
  }
}
