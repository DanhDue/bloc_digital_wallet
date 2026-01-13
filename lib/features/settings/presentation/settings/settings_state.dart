// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/settings_entity.dart';

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

/// Loading state
class SettingsLoading extends SettingsState {
  const SettingsLoading();

  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class SettingssLoaded extends SettingsState {
  final List<SettingsEntity> items;

  const SettingssLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Error state
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
