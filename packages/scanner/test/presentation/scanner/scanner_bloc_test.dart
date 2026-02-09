// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';
import 'package:scanner/domain/usecases/get_scanner_usecase.dart';
import 'package:scanner/presentation/scanner/scanner_action.dart';
import 'package:scanner/presentation/scanner/scanner_bloc.dart';
import 'package:scanner/presentation/scanner/scanner_state.dart';
import 'package:core/core.dart' hide test;

import 'scanner_bloc_test.mocks.dart';

@GenerateMocks([GetScannerUseCase])
void main() {
  late ScannerBloc bloc;
  late MockGetScannerUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetScannerUseCase();
    bloc = ScannerBloc(mockUseCase);
  });

  const tScannerEntity = ScannerEntity(id: '1', name: 'Test', description: 'Description');

  test('initial state should be initial', () {
    expect(bloc.state.status, ScannerStatus.initial);
  });

  blocTest<ScannerBloc, ScannerState>(
    'emits [loading, success] when started is added and usecase returns success',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => const Right(tScannerEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const ScannerAction.started()),
    expect: () => [
      const ScannerState(status: ScannerStatus.loading),
      isA<ScannerState>()
          .having((s) => s.status, 'status', ScannerStatus.success)
          .having((s) => s.uiModel, 'uiModel', isNotNull),
    ],
    verify: (_) {
      verify(mockUseCase());
    },
  );
}
