// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';

sealed class D3VotionState extends BaseState with EquatableMixin {
  const D3VotionState();
}

class D3VotionInitial extends D3VotionState {
  const D3VotionInitial();

  @override
  List<Object?> get props => [];
}

class D3VotionLoading extends D3VotionState {
  const D3VotionLoading();

  @override
  List<Object?> get props => [];
}

class D3VotionLoaded extends D3VotionState {
  final D3VotionEntity data;

  const D3VotionLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class D3VotionError extends D3VotionState {
  final String message;

  const D3VotionError(this.message);

  @override
  List<Object?> get props => [message];
}
