// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_sample_usecase.dart';
import '../../domain/usecases/get_all_samples_usecase.dart';
import 'sample_action.dart';
import 'sample_state.dart';
import 'sample_event.dart';

/// Sample BLoC demonstrating all action handlers
@injectable
class SampleBloc extends MviBloc<
  SampleAction,
  SampleState,
  SampleEvent
> {
  final GetSampleUseCase getSampleUseCase;
  final GetAllSamplesUseCase getAllSamplesUseCase;

  SampleBloc({
    required this.getSampleUseCase,
    required this.getAllSamplesUseCase,
  }) : super(const SampleInitial()) {
    // Register all action handlers
    handleAction(null, _onLoadAllSamples);
    handleAction(null, _onLoadSample);
    handleAction(null, _onCreateSample);
    handleAction(null, _onUpdateSample);
    handleAction(null, _onDeleteSample);
    handleAction(null, _onRefreshSamples);
  }

  @override
  void onAction(SampleAction action) {
    add(action);
  }

  /// Load all items
  Future<void> _onLoadAllSamples(
    LoadAllSamplesAction action,
    Emitter<SampleState> emit,
  ) async {
    emit(const SampleLoading());

    final result = await getAllSamplesUseCase();

    result.fold(
      (failure) {
        emit(SampleError(failure.message));
        emitEvent(ShowMessage.error(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const SampleEmpty());
        } else {
          emit(SamplesLoaded(items));
        }
      },
    );
  }

  /// Load single item by id
  Future<void> _onLoadSample(
    LoadSampleAction action,
    Emitter<SampleState> emit,
  ) async {
    emit(const SampleLoading());

    final result = await getSampleUseCase(action.id);

    result.fold(
      (failure) {
        emit(SampleError(failure.message));
        emitEvent(ShowMessage.error(failure.message));
      },
      (item) => emit(SampleLoaded(item)),
    );
  }

  /// Create new item
  Future<void> _onCreateSample(
    CreateSampleAction action,
    Emitter<SampleState> emit,
  ) async {
    emit(const SampleCreating());
    // TODO: Implement create logic with use case
    emitEvent(const ShowMessage.success('Created successfully'));
    emitEvent(const NavigateBack());
  }

  /// Update existing item
  Future<void> _onUpdateSample(
    UpdateSampleAction action,
    Emitter<SampleState> emit,
  ) async {
    // TODO: Implement update logic with use case
    emitEvent(const ShowMessage.success('Updated successfully'));
    emitEvent(const NavigateBack());
  }

  /// Delete item
  Future<void> _onDeleteSample(
    DeleteSampleAction action,
    Emitter<SampleState> emit,
  ) async {
    emit(SampleDeleting(action.id));
    // TODO: Implement delete logic with use case
    emitEvent(const ShowMessage.success('Deleted successfully'));
    // Refresh list after delete
    add(const LoadAllSamplesAction());
  }

  /// Refresh items
  Future<void> _onRefreshSamples(
    RefreshSamplesAction action,
    Emitter<SampleState> emit,
  ) async {
    add(const LoadAllSamplesAction());
  }
}
