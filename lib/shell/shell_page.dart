// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:framework/framework.dart';

import 'package:bloc_digital_wallet/shell/shell_bloc.dart';
import 'package:bloc_digital_wallet/shell/shell_action.dart';
import 'package:bloc_digital_wallet/shell/shell_event.dart';
import 'package:bloc_digital_wallet/shell/shell_state.dart';
import 'package:bloc_digital_wallet/shell/widgets/custom_bottom_nav_bar.dart';
import 'package:scanner/scanner.dart';
import 'package:settings/settings.dart';
import 'package:transaction/transaction.dart';
import 'package:trends/trends.dart';
import 'package:wallet/wallet.dart';

@RoutePage()
class ShellPage extends BaseMviPage<ShellBloc, ShellAction, ShellState, ShellEvent> {
  const ShellPage({super.key});

  @override
  ShellAction? get initialAction => const ShellAction.started();

  @override
  Widget buildScaffold(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<ShellBloc>().onAction(const ShellAction.backPressed());
      },
      child: Scaffold(
        body: buildBody(context),
        bottomNavigationBar: BlocBuilder<ShellBloc, ShellState>(
          buildWhen: (previous, current) => previous.currentTabIndex != current.currentTabIndex,
          builder: (context, state) {
            return CustomBottomNavBar(
              currentIndex: state.currentTabIndex,
              onTap: (index) {
                context.read<ShellBloc>().onAction(ShellAction.tabChanged(index));
              },
              onDoubleTap: (index) {
                context.read<ShellBloc>().onAction(ShellAction.tabDoubleTapped(index));
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget handleState(BuildContext context, ShellState state) {
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
  void handleEvent(BuildContext context, ShellEvent event) {
    event.map(
      showExitToast: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.home.main.exitToast),
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
