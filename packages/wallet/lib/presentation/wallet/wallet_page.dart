// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'wallet_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

@RoutePage()
class WalletPage extends BaseMviPage<WalletBloc, WalletState, WalletEvent> {
  const WalletPage({super.key});

  @override
  Widget handleState(BuildContext context, WalletState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: const Center(child: Text('Wallet Feature')),
    );
  }

  @override
  void handleEvent(BuildContext context, WalletEvent event) {
    // TODO: Handle side-effect events (navigation, toasts, etc.)
  }
}
