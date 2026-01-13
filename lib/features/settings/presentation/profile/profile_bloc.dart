// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_action.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends MviBloc<ProfileAction, ProfileState, ProfileEvent> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileBloc(this._getProfileUseCase) : super(const ProfileInitial()) {
    handleActionDroppable<LoadProfileAction>(_onLoadProfile);
  }

  @override
  void onAction(ProfileAction action) {
    add(action);
  }

  Future<void> _onLoadProfile(LoadProfileAction action, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());

    final result = await _getProfileUseCase();

    result.fold((failure) {
      emit(ProfileError(failure.message));
      emitEvent(ShowMessage.error(failure.message));
    }, (items) => emit(ProfileSuccess(items)));
  }
}
