// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/presentation/home/home_action.dart';
import 'package:home/presentation/home/home_bloc.dart';
import 'package:home/presentation/home/home_event.dart';
import 'package:home/presentation/home/home_state.dart';

void main() {
  late HomeBloc bloc;
  late List<HomeEvent> events;

  setUp(() {
    bloc = HomeBloc();
    events = [];
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should have currentTabIndex == 0', () {
    expect(bloc.state, const HomeState());
    expect(bloc.state.currentTabIndex, 0);
  });

  blocTest<HomeBloc, HomeState>(
    'emits state with currentTabIndex == 2 when tabChanged(2)',
    build: () => bloc,
    act: (bloc) => bloc.add(const HomeAction.tabChanged(2)),
    expect: () => [const HomeState(currentTabIndex: 2)],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with currentTabIndex == 3 when tabChanged(3)',
    build: () => bloc,
    act: (bloc) => bloc.add(const HomeAction.tabChanged(3)),
    expect: () => [const HomeState(currentTabIndex: 3)],
  );

  blocTest<HomeBloc, HomeState>(
    'does not emit new state when tabDoubleTapped on current tab',
    build: () => bloc,
    act: (bloc) => bloc.add(const HomeAction.tabDoubleTapped(0)),
    expect: () => <HomeState>[],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with updated tab when tabDoubleTapped on different tab',
    build: () => bloc,
    act: (bloc) => bloc.add(const HomeAction.tabDoubleTapped(4)),
    expect: () => [const HomeState(currentTabIndex: 4)],
  );

  blocTest<HomeBloc, HomeState>(
    'emits showExitToast event on first back press',
    build: () {
      // Listen to the event stream to capture side effects
      bloc.events.listen(events.add);
      return bloc;
    },
    act: (bloc) => bloc.add(const HomeAction.backPressed()),
    expect: () => <HomeState>[],
    verify: (bloc) {
      expect(events, equals([const HomeEvent.showExitToast()]));
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits exitApp event on second back press within 2 seconds',
    build: () {
      bloc.events.listen(events.add);
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const HomeAction.backPressed());
      await Future<void>.delayed(const Duration(milliseconds: 500));
      bloc.add(const HomeAction.backPressed());
    },
    expect: () => <HomeState>[],
    verify: (bloc) {
      expect(events, equals([const HomeEvent.showExitToast(), const HomeEvent.exitApp()]));
    },
  );
}
