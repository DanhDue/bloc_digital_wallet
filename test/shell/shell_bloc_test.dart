// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_digital_wallet/shell/shell_action.dart';
import 'package:bloc_digital_wallet/shell/shell_bloc.dart';
import 'package:bloc_digital_wallet/shell/shell_event.dart';
import 'package:bloc_digital_wallet/shell/shell_state.dart';

void main() {
  late ShellBloc bloc;
  late List<ShellEvent> events;

  setUp(() {
    bloc = ShellBloc();
    events = [];
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should have currentTabIndex == 0', () {
    expect(bloc.state, const ShellState());
    expect(bloc.state.currentTabIndex, 0);
  });

  blocTest<ShellBloc, ShellState>(
    'emits state with currentTabIndex == 2 when tabChanged(2)',
    build: () => bloc,
    act: (bloc) => bloc.add(const ShellAction.tabChanged(2)),
    expect: () => [const ShellState(currentTabIndex: 2)],
  );

  blocTest<ShellBloc, ShellState>(
    'emits state with currentTabIndex == 3 when tabChanged(3)',
    build: () => bloc,
    act: (bloc) => bloc.add(const ShellAction.tabChanged(3)),
    expect: () => [const ShellState(currentTabIndex: 3)],
  );

  blocTest<ShellBloc, ShellState>(
    'does not emit new state when tabDoubleTapped on current tab',
    build: () => bloc,
    act: (bloc) => bloc.add(const ShellAction.tabDoubleTapped(0)),
    expect: () => <ShellState>[],
  );

  blocTest<ShellBloc, ShellState>(
    'emits state with updated tab when tabDoubleTapped on different tab',
    build: () => bloc,
    act: (bloc) => bloc.add(const ShellAction.tabDoubleTapped(4)),
    expect: () => [const ShellState(currentTabIndex: 4)],
  );

  blocTest<ShellBloc, ShellState>(
    'emits showExitToast event on first back press',
    build: () {
      // Listen to the event stream to capture side effects
      bloc.events.listen(events.add);
      return bloc;
    },
    act: (bloc) => bloc.add(const ShellAction.backPressed()),
    expect: () => <ShellState>[],
    verify: (bloc) {
      expect(events, equals([const ShellEvent.showExitToast()]));
    },
  );

  blocTest<ShellBloc, ShellState>(
    'emits exitApp event on second back press within 2 seconds',
    build: () {
      bloc.events.listen(events.add);
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const ShellAction.backPressed());
      await Future<void>.delayed(const Duration(milliseconds: 500));
      bloc.add(const ShellAction.backPressed());
    },
    expect: () => <ShellState>[],
    verify: (bloc) {
      expect(events, equals([const ShellEvent.showExitToast(), const ShellEvent.exitApp()]));
    },
  );
}
