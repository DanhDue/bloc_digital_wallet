// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import 'settings_action.dart';
import 'settings_state.dart';
import 'settings_event.dart';

@injectable
class SettingsBloc extends MviBloc<SettingsAction, SettingsState, SettingsEvent> {
  final GetSettingsUseCase _getSettingsUseCase;

  SettingsBloc(this._getSettingsUseCase) : super(const SettingsInitial()) {
    handleAction(null, _onLoadSettings);
  }

  @override
  void onAction(SettingsAction action) {
    add(action);
  }

  Future<void> _onLoadSettings(LoadSettingsAction action, Emitter<SettingsState> emit) async {
    emit(const SettingsLoading());

    final result = await _getSettingsUseCase();

    result.fold((failure) {
      emit(SettingsError(failure.message));
      emitEvent(ShowMessage.error(failure.message));
    }, (items) => emit(SettingssLoaded(items)));
  }
}
