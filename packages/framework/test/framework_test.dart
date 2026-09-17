// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:framework/framework.dart';

void main() {
  group('Framework UiState Tests', () {
    test('InitialState props are empty', () {
      const state1 = InitialState();
      const state2 = InitialState();
      expect(state1, equals(state2));
      expect(state1.props, isEmpty);
    });

    test('LoadingState supports optional message and equality', () {
      const state1 = LoadingState('loading');
      const state2 = LoadingState('loading');
      const state3 = LoadingState('different');

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state1.message, equals('loading'));
      expect(state1.props, equals(['loading']));
    });

    test('SuccessState encapsulates data and message', () {
      const state1 = SuccessState<String>(data: 'success_data', message: 'ok');
      const state2 = SuccessState<String>(data: 'success_data', message: 'ok');

      expect(state1, equals(state2));
      expect(state1.data, equals('success_data'));
      expect(state1.message, equals('ok'));
    });

    test('ErrorState encapsulates message and error', () {
      final error = Exception('something went wrong');
      final state1 = ErrorState(message: 'error occurred', error: error);
      final state2 = ErrorState(message: 'error occurred', error: error);

      expect(state1, equals(state2));
      expect(state1.message, equals('error occurred'));
      expect(state1.error, equals(error));
    });

    test('EmptyState supports message and equality', () {
      const state1 = EmptyState('no data');
      const state2 = EmptyState('no data');
      expect(state1, equals(state2));
      expect(state1.message, equals('no data'));
    });

    test('LoadedState encapsulates data', () {
      const state1 = LoadedState<int>(42);
      const state2 = LoadedState<int>(42);
      expect(state1, equals(state2));
      expect(state1.data, equals(42));
    });
  });
}
