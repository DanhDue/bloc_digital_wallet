// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/presentation/wallet/wallet_action.dart';
import 'package:wallet/presentation/wallet/wallet_bloc.dart';
import 'package:wallet/presentation/wallet/wallet_state.dart';

void main() {
  late WalletBloc bloc;

  setUp(() {
    bloc = WalletBloc();
  });

  test('initial state should be initial', () {
    expect(bloc.state.status, WalletStatus.initial);
  });

  blocTest<WalletBloc, WalletState>(
    'emits [success] when started is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const WalletAction.started()),
    expect: () => [isA<WalletState>().having((s) => s.status, 'status', WalletStatus.success)],
  );
}
