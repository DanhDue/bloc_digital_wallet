// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

import '../../../../core/architecture/architecture.dart';

/// States for Settings feature
sealed class SettingsState extends BaseState with EquatableMixin {
  const SettingsState();
}

/// Initial state
class SettingsInitial extends SettingsState {
  const SettingsInitial();

  @override
  List<Object?> get props => [];
}
