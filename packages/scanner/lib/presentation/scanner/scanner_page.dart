// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'scanner_bloc.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

@RoutePage()
class ScannerPage extends BaseMviPage<ScannerBloc, ScannerState, ScannerEvent> {
  const ScannerPage({super.key});

  @override
  Widget handleState(BuildContext context, ScannerState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: const Center(child: Text('Scanner Feature')),
    );
  }

  @override
  void handleEvent(BuildContext context, ScannerEvent event) {
    // TODO: Handle side-effect events (navigation, toasts, etc.)
  }
}
