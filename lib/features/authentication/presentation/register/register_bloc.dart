// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/register_with_email_usecase.dart';
import 'register_action.dart';
import 'register_event.dart';
import 'register_state.dart';

@injectable
class RegisterBloc extends MviBloc<RegisterAction, RegisterState, RegisterEvent> {
  final RegisterWithEmailUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterInitial()) {
    handleActionDroppable<RegisterWithEmailAction>(_onRegisterWithEmail);
  }

  @override
  void onAction(RegisterAction action) {
    add(action);
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailAction action,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    final result = await _registerUseCase(
      email: action.email,
      password: action.password,
      firstName: action.firstName,
      lastName: action.lastName,
      phoneNumber: action.phoneNumber,
      dateOfBirth: action.dateOfBirth,
    );

    result.fold(
      (failure) {
        emit(RegisterError(failure.message));
        emitEvent(ShowRegisterErrorMessage(failure.message));
      },
      (user) {
        emit(RegisterSuccess(user));
        emitEvent(ShowRegisterSuccessMessage('Registration successful'));
      },
    );
  }
}
