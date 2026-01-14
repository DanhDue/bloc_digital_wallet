// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/architecture/architecture.dart';
import 'settings_action.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends MviBloc<SettingsAction, SettingsState, SettingsEvent> {
  SettingsBloc() : super(const SettingsInitial()) {
    handleActionDroppable(_initialization);
    handleActionDroppable(_onNavigateToProfile);
  }

  Future<void> _onNavigateToProfile(NavigateToProfile action, Emitter<SettingsState> emit) async {
    emitEvent(const NavigateToProfileEvent());
  }

  @override
  void onAction(SettingsAction action) {
    add(action);
  }

  Future<void> _initialization(LoadSettingsAction action, Emitter<SettingsState> emit) async {
    emit(const SettingsInitial());
  }
}
