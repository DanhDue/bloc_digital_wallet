// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

@RoutePage()
class HomePage extends BaseMviPage<HomeBloc, HomeState, HomeEvent> {
  const HomePage({super.key});

  @override
  Widget handleState(BuildContext context, HomeState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Feature')),
    );
  }

  @override
  void handleEvent(BuildContext context, HomeEvent event) {
    // TODO: Handle side-effect events (navigation, toasts, etc.)
  }
}
