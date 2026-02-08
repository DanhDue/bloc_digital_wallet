// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'transaction_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

@RoutePage()
class TransactionPage
    extends BaseMviPage<TransactionBloc, TransactionState, TransactionEvent> {
  const TransactionPage({super.key});

  @override
  Widget handleState(BuildContext context, TransactionState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: const Center(child: Text('Transaction Feature')),
    );
  }

  @override
  void handleEvent(BuildContext context, TransactionEvent event) {
    // TODO: Handle side-effect events (navigation, toasts, etc.)
  }
}
