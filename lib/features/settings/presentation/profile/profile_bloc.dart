// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import 'profile_action.dart';
import 'profile_state.dart';
import 'profile_event.dart';

/// ============================================================================
/// Profile BLoC
/// ============================================================================
/// The BLoC processes Actions and emits States/Events.
///
/// HOW TO EXTEND:
/// 1. Add use case dependencies via constructor injection
/// 2. Register action handlers in constructor using handleAction methods
/// 3. Implement handler methods that emit new states/events
///
/// EXAMPLE - Adding use case and handler:
/// ```dart
/// @injectable
/// class ProfileBloc extends MviBloc<...> {
///   final GetProfileUseCase _getProfileUseCase;
///
///   ProfileBloc(this._getProfileUseCase)
///       : super(const ProfileInitial()) {
///     handleActionDroppable<LoadProfileAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadProfileAction action,
///     Emitter<ProfileState> emit,
///   ) async {
///     emit(const ProfileLoading());
///     final result = await _getProfileUseCase();
///     result.fold(
///       (failure) => emit(ProfileError(failure.message)),
///       (data) => emit(ProfileSuccess(data)),
///     );
///   }
/// }
/// ```
///
/// ACTION HANDLER TYPES:
/// - handleActionDroppable: Drops new actions while processing (default)
/// - handleActionSequential: Queues actions, processes one at a time
/// - handleActionConcurrent: Processes actions concurrently
/// ============================================================================

@injectable
class ProfileBloc extends MviBloc<ProfileAction, ProfileState, ProfileEvent> {
  ProfileBloc() : super(const ProfileInitial()) {
    // TODO: Register action handlers here
    // handleActionDroppable<LoadProfileAction>(_onLoad);
  }

  @override
  void onAction(ProfileAction action) {
    add(action);
  }

  // TODO: Implement action handlers
  // Future<void> _onLoad(
  //   LoadProfileAction action,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   // Handle loading
  // }
}
