// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:scanner/domain/usecases/get_scanner_usecase.dart';
import 'package:scanner/presentation/scanner/models/scanner_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'scanner_action.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

@injectable
class ScannerBloc extends MviBloc<ScannerAction, ScannerState, ScannerEvent> {
  final GetScannerUseCase _getScannerUseCase;

  ScannerBloc(this._getScannerUseCase) : super(const ScannerState()) {
    on<ScannerAction>((action, emit) {
      action.when(started: () => _onStarted(emit));
    });
  }

  Future<void> _onStarted(Emitter<ScannerState> emit) async {
    emit(state.copyWith(status: ScannerStatus.loading));
    final result = await _getScannerUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ScannerStatus.failure, errorMessage: failure.message));
        emitEvent(const ScannerEvent.initial());
      },
      (entity) {
        final uiModel = ScannerUiModel.fromEntity(entity);
        emit(state.copyWith(status: ScannerStatus.success, uiModel: uiModel));
      },
    );
  }
}
