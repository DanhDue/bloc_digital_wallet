// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network/network.dart';
import 'package:onboard/domain/usecases/health_check_usecase.dart';
import 'package:onboard/presentation/splash/splash_action.dart';
import 'package:onboard/presentation/splash/splash_bloc.dart';
import 'package:onboard/presentation/splash/splash_state.dart';
import 'package:settings/data/models/sync/bootstrap_translation_item.dart';
import 'package:settings/settings.dart';

class MockHealthCheckUseCase extends Mock implements HealthCheckUseCase {
  @override
  Future<Either<Failure, BaseResponseObject<dynamic>>> call() =>
      super.noSuchMethod(
        Invocation.method(#call, []),
        returnValue: Future.value(
          Right<Failure, BaseResponseObject<dynamic>>(
            BaseResponseObject(data: 'ok', success: true),
          ),
        ),
      ) as Future<Either<Failure, BaseResponseObject<dynamic>>>;
}

class MockBootstrapUseCase extends Mock implements BootstrapUseCase {
  @override
  Future<Either<Failure, SyncBootstrapResponse>> call() =>
      super.noSuchMethod(
        Invocation.method(#call, []),
        returnValue: Future.value(
          Right<Failure, SyncBootstrapResponse>(
            SyncBootstrapResponse(),
          ),
        ),
      ) as Future<Either<Failure, SyncBootstrapResponse>>;
}

class MockFetchTranslationUseCase extends Mock implements FetchTranslationUseCase {
  @override
  Future<Either<Failure, void>> call(BootstrapTranslationItem item) =>
      super.noSuchMethod(
        Invocation.method(#call, [item]),
        returnValue: Future.value(const Right<Failure, void>(null)),
      ) as Future<Either<Failure, void>>;
}

void main() {
  late MockHealthCheckUseCase mockHealthCheck;
  late MockBootstrapUseCase mockBootstrap;
  late MockFetchTranslationUseCase mockFetchTranslation;
  late SplashBloc splashBloc;

  setUp(() {
    mockHealthCheck = MockHealthCheckUseCase();
    mockBootstrap = MockBootstrapUseCase();
    mockFetchTranslation = MockFetchTranslationUseCase();

    when(mockBootstrap.call()).thenAnswer(
      (_) => Future<Either<Failure, SyncBootstrapResponse>>.value(
        Right(SyncBootstrapResponse()),
      ),
    );
    when(mockHealthCheck.call()).thenAnswer(
      (_) => Future<Either<Failure, BaseResponseObject<dynamic>>>.value(
        Right(BaseResponseObject(data: 'healthy', success: true)),
      ),
    );

    splashBloc = SplashBloc(
      mockHealthCheck,
      mockBootstrap,
      mockFetchTranslation,
      visibilityDelay: Duration.zero,
      lottieDelay: Duration.zero,
      minSplashDuration: Duration.zero,
    );
  });

  tearDown(() {
    splashBloc.close();
  });

  group('SplashBloc Tests', () {
    test('initial state is SplashInitial', () {
      expect(splashBloc.state, equals(const SplashInitial()));
    });

    blocTest<SplashBloc, SplashState>(
      'emits loading states and navigates next on successful health check',
      build: () => splashBloc,
      act: (bloc) => bloc.onAction(const InitSplashAction()),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        const SplashLoading(
          isAnimationVisible: false,
          isAnimationPlaying: false,
          showRestartWarning: false,
        ),
        const SplashLoading(
          isAnimationVisible: true,
          isAnimationPlaying: false,
          showRestartWarning: false,
        ),
        const SplashLoading(
          isAnimationVisible: true,
          isAnimationPlaying: true,
          showRestartWarning: false,
        ),
        const SplashSuccess(),
      ],
      verify: (_) {
        verify(mockHealthCheck.call()).called(1);
      },
    );

    blocTest<SplashBloc, SplashState>(
      'emits error state and warning when health check fails',
      build: () {
        when(mockHealthCheck.call()).thenAnswer(
          (_) => Future<Either<Failure, BaseResponseObject<dynamic>>>.value(
            const Left(ServerFailure(message: 'Health check failed')),
          ),
        );
        return splashBloc;
      },
      act: (bloc) => bloc.onAction(const InitSplashAction()),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        const SplashLoading(
          isAnimationVisible: false,
          isAnimationPlaying: false,
          showRestartWarning: false,
        ),
        const SplashLoading(
          isAnimationVisible: true,
          isAnimationPlaying: false,
          showRestartWarning: false,
        ),
        const SplashLoading(
          isAnimationVisible: true,
          isAnimationPlaying: true,
          showRestartWarning: false,
        ),
        const SplashError(message: 'Health check failed', showRestartWarning: true),
      ],
    );
  });
}
