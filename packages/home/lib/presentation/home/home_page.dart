// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/generated/translations.dart';
import 'package:framework/framework.dart';

import 'package:home/presentation/home/home_bloc.dart';
import 'package:home/presentation/home/home_action.dart';
import 'package:home/presentation/home/home_event.dart';
import 'package:home/presentation/home/home_state.dart';
import 'package:home/presentation/home/widgets/custom_bottom_nav_bar.dart';
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';
import 'package:transaction/transaction.dart';
import 'package:trends/trends.dart';
import 'package:wallet/wallet.dart';

@RoutePage()
class HomePage extends BaseMviPage<HomeBloc, HomeAction, HomeState, HomeEvent> {
  const HomePage({super.key});

  @override
  HomeAction? get initialAction => const HomeAction.started();

  @override
  Widget buildScaffold(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<HomeBloc>().onAction(const HomeAction.backPressed());
      },
      child: Scaffold(
        body: buildBody(context),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) => previous.currentTabIndex != current.currentTabIndex,
          builder: (context, state) {
            return CustomBottomNavBar(
              currentIndex: state.currentTabIndex,
              onTap: (index) {
                context.read<HomeBloc>().onAction(HomeAction.tabChanged(index));
              },
              onDoubleTap: (index) {
                context.read<HomeBloc>().onAction(HomeAction.tabDoubleTapped(index));
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget handleState(BuildContext context, HomeState state) {
    return SafeArea(
      top: false,
      bottom: false,
      child: IndexedStack(
        index: state.currentTabIndex,
        children: const [
          WalletPage(),
          TransactionPage(),
          ScannerPage(),
          TrendsPage(),
          SettingsPage(),
        ],
      ),
    );
  }

  @override
  void handleEvent(BuildContext context, HomeEvent event) {
    event.map(
      showExitToast: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tHome.home.main.exitToast),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      exitApp: (_) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        }
      },
    );
  }
}
