// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/generated/translations.dart';
import 'package:framework/framework.dart';

import 'package:home/presentation/home/home_bloc.dart';
import 'package:home/presentation/home/home_action.dart';
import 'package:home/presentation/home/home_event.dart';
import 'package:home/presentation/home/home_state.dart';

@RoutePage()
class HomePage extends BaseMviPage<HomeBloc, HomeAction, HomeState, HomeEvent> {
  const HomePage({super.key});

  @override
  HomeAction? get initialAction => const HomeAction.started();

  @override
  Widget handleState(BuildContext context, HomeState state) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tHome.home.title)),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text('Error: ${state.error}'))
          : ListView.builder(
              itemCount: state.homes.length,
              itemBuilder: (context, index) {
                final home = state.homes[index];
                return ListTile(
                  title: Text(home.name),
                  subtitle: Text(home.id),
                  onTap: () {
                    context.read<HomeBloc>().onAction(HomeAction.onHomeItemClicked(home.id));
                  },
                );
              },
            ),
    );
  }

  @override
  void handleEvent(BuildContext context, HomeEvent event) {
    event.map(
      navigateToDetails: (e) {
        // TODO: Implement actual navigation when the route is ready
        // AutoRouter.of(context).push...
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigate to ${e.id}')));
      },
      showError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      },
    );
  }
}
