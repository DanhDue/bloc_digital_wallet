// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/settings_entity.dart';

/// States for Profile subfeature
sealed class ProfileState extends BaseState with EquatableMixin {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Success state with data
class ProfileSuccess extends ProfileState {
  final List<SettingsEntity> items;
  const ProfileSuccess(this.items);

  @override
  List<Object?> get props => [items];
}

/// Error state
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
