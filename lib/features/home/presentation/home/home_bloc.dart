// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_home_usecase.dart';
import '../../domain/usecases/get_all_homes_usecase.dart';
import 'home_action.dart';
import 'home_state.dart';
import 'home_event.dart';

@injectable
class HomeBloc extends MviBloc<HomeAction, HomeState, HomeEvent> {
  final GetHomeUseCase getHomeUseCase;
  final GetAllHomesUseCase getAllHomesUseCase;

  HomeBloc({required this.getHomeUseCase, required this.getAllHomesUseCase})
    : super(const HomeNavigationState()) {
    // Register action handlers
    handleAction(null, _onChangeTab);
    handleAction(null, _onOpenScanner);
    handleAction(null, _onLoadAllHomes);
    handleAction(null, _onLoadHome);
    handleAction(null, _onCreateHome);
    handleAction(null, _onUpdateHome);
    handleAction(null, _onDeleteHome);
    handleAction(null, _onRefreshHomes);
  }

  /// Single entry point for all actions (Following Android pattern)
  /// This is the ONLY method View should call
  @override
  void onAction(HomeAction action) {
    add(action);
  }

  /// Handle tab change
  Future<void> _onChangeTab(ChangeTabAction action, Emitter<HomeState> emit) async {
    // Skip center tab (index 2) - it's the FAB
    if (action.tabIndex == 2) {
      emitEvent(const NavigateToScanner());
      return;
    }

    final currentState = state;
    if (currentState is HomeNavigationState) {
      emit(currentState.copyWith(currentTabIndex: action.tabIndex));
    } else {
      emit(HomeNavigationState(currentTabIndex: action.tabIndex));
    }
  }

  /// Handle scanner open (FAB)
  Future<void> _onOpenScanner(OpenScannerAction action, Emitter<HomeState> emit) async {
    emitEvent(const NavigateToScanner());
  }

  Future<void> _onLoadAllHomes(LoadAllHomesAction action, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    final result = await getAllHomesUseCase();

    result.fold(
      (failure) {
        emit(HomeError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const HomeEmpty());
        } else {
          emit(HomesLoaded(items));
        }
      },
    );
  }

  Future<void> _onLoadHome(LoadHomeAction action, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    final result = await getHomeUseCase(action.id);

    result.fold((failure) {
      emit(HomeError(failure.message));
      emitEvent(ShowErrorMessage(failure.message));
    }, (item) => emit(HomeLoaded(item)));
  }

  Future<void> _onCreateHome(CreateHomeAction action, Emitter<HomeState> emit) async {
    // TODO: Implement create logic
    emitEvent(const ShowSuccessMessage('Created successfully'));
  }

  Future<void> _onUpdateHome(UpdateHomeAction action, Emitter<HomeState> emit) async {
    // TODO: Implement update logic
    emitEvent(const ShowSuccessMessage('Updated successfully'));
  }

  Future<void> _onDeleteHome(DeleteHomeAction action, Emitter<HomeState> emit) async {
    // TODO: Implement delete logic
    emitEvent(const ShowSuccessMessage('Deleted successfully'));
  }

  Future<void> _onRefreshHomes(RefreshHomesAction action, Emitter<HomeState> emit) async {
    // Reload all items
    add(const LoadAllHomesAction());
  }
}
