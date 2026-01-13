// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_trends_usecase.dart';
import '../../domain/usecases/get_all_trendss_usecase.dart';
import 'trends_action.dart';
import 'trends_state.dart';
import 'trends_event.dart';

@injectable
class TrendsBloc extends MviBloc<TrendsAction, TrendsState, TrendsEvent> {
  final GetTrendsUseCase getTrendsUseCase;
  final GetAllTrendssUseCase getAllTrendssUseCase;

  TrendsBloc({required this.getTrendsUseCase, required this.getAllTrendssUseCase})
    : super(const TrendsInitial()) {
    // Register action handlers
    handleAction(null, _onLoadAllTrendss);
    handleAction(null, _onLoadTrends);
    handleAction(null, _onCreateTrends);
    handleAction(null, _onUpdateTrends);
    handleAction(null, _onDeleteTrends);
    handleAction(null, _onRefreshTrendss);
  }

  /// Single entry point for all actions (Following Android pattern)
  /// This is the ONLY method View should call
  @override
  void onAction(TrendsAction action) {
    add(action);
  }

  Future<void> _onLoadAllTrendss(LoadAllTrendssAction action, Emitter<TrendsState> emit) async {
    emit(const TrendsLoading());

    final result = await getAllTrendssUseCase();

    result.fold(
      (failure) {
        emit(TrendsError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const TrendsEmpty());
        } else {
          emit(TrendssLoaded(items));
        }
      },
    );
  }

  Future<void> _onLoadTrends(LoadTrendsAction action, Emitter<TrendsState> emit) async {
    emit(const TrendsLoading());

    final result = await getTrendsUseCase(action.id);

    result.fold((failure) {
      emit(TrendsError(failure.message));
      emitEvent(ShowErrorMessage(failure.message));
    }, (item) => emit(TrendsLoaded(item)));
  }

  Future<void> _onCreateTrends(CreateTrendsAction action, Emitter<TrendsState> emit) async {
    // TODO: Implement create logic
    emitEvent(const ShowSuccessMessage('Created successfully'));
  }

  Future<void> _onUpdateTrends(UpdateTrendsAction action, Emitter<TrendsState> emit) async {
    // TODO: Implement update logic
    emitEvent(const ShowSuccessMessage('Updated successfully'));
  }

  Future<void> _onDeleteTrends(DeleteTrendsAction action, Emitter<TrendsState> emit) async {
    // TODO: Implement delete logic
    emitEvent(const ShowSuccessMessage('Deleted successfully'));
  }

  Future<void> _onRefreshTrendss(RefreshTrendssAction action, Emitter<TrendsState> emit) async {
    // Reload all items
    add(const LoadAllTrendssAction());
  }
}
