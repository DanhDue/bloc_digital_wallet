// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_scanner_usecase.dart';
import '../../domain/usecases/get_all_scanners_usecase.dart';
import 'scanner_action.dart';
import 'scanner_state.dart';
import 'scanner_event.dart';

@injectable
class ScannerBloc extends MviBloc<ScannerAction, ScannerState, ScannerEvent> {
  final GetScannerUseCase getScannerUseCase;
  final GetAllScannersUseCase getAllScannersUseCase;

  ScannerBloc({required this.getScannerUseCase, required this.getAllScannersUseCase})
    : super(const ScannerInitial()) {
    // Register action handlers
    handleAction(null, _onLoadAllScanners);
    handleAction(null, _onLoadScanner);
    handleAction(null, _onCreateScanner);
    handleAction(null, _onUpdateScanner);
    handleAction(null, _onDeleteScanner);
    handleAction(null, _onRefreshScanners);
  }

  /// Single entry point for all actions (Following Android pattern)
  /// This is the ONLY method View should call
  @override
  void onAction(ScannerAction action) {
    add(action);
  }

  Future<void> _onLoadAllScanners(LoadAllScannersAction action, Emitter<ScannerState> emit) async {
    emit(const ScannerLoading());

    final result = await getAllScannersUseCase();

    result.fold(
      (failure) {
        emit(ScannerError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const ScannerEmpty());
        } else {
          emit(ScannersLoaded(items));
        }
      },
    );
  }

  Future<void> _onLoadScanner(LoadScannerAction action, Emitter<ScannerState> emit) async {
    emit(const ScannerLoading());

    final result = await getScannerUseCase(action.id);

    result.fold((failure) {
      emit(ScannerError(failure.message));
      emitEvent(ShowErrorMessage(failure.message));
    }, (item) => emit(ScannerLoaded(item)));
  }

  Future<void> _onCreateScanner(CreateScannerAction action, Emitter<ScannerState> emit) async {
    // TODO: Implement create logic
    emitEvent(const ShowSuccessMessage('Created successfully'));
  }

  Future<void> _onUpdateScanner(UpdateScannerAction action, Emitter<ScannerState> emit) async {
    // TODO: Implement update logic
    emitEvent(const ShowSuccessMessage('Updated successfully'));
  }

  Future<void> _onDeleteScanner(DeleteScannerAction action, Emitter<ScannerState> emit) async {
    // TODO: Implement delete logic
    emitEvent(const ShowSuccessMessage('Deleted successfully'));
  }

  Future<void> _onRefreshScanners(RefreshScannersAction action, Emitter<ScannerState> emit) async {
    // Reload all items
    add(const LoadAllScannersAction());
  }
}
