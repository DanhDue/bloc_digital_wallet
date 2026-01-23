// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/features/home/presentation/home/home_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';

import '../../../../core/architecture/architecture.dart';

import 'home_action.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

@RoutePage()
class HomePage extends BaseMviStatefulPage<HomeBloc, HomeState, HomeEvent> {
  const HomePage({super.key});

  @override
  BaseMviPageState<HomeBloc, HomeState, HomeEvent, HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseMviPageState<HomeBloc, HomeState, HomeEvent, HomePage> {
  DateTime? _lastPressedAt;

  @override
  Widget buildScaffold(BuildContext context) {
    // Override to return AutoTabsRouter directly, bypassing default Scaffold
    // because AutoTabsRouter provides its own Scaffold inside builder
    return buildBody(context);
  }

  @override
  Widget handleState(BuildContext context, HomeState state) {
    return AutoTabsRouter(
      routes: const [WalletRoute(), TransactionRoute(), TrendsRoute(), SettingsTabRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: _onPopInvoked,
          child: Scaffold(
            extendBody: true,
            body: SafeArea(top: true, bottom: false, child: child),
            bottomNavigationBar: HomeBottomNavigationBar(
              tabsRouter: tabsRouter,
              onOpenScanner: _handleOpenScanner,
            ),
          ),
        );
      },
    );
  }

  void _handleOpenScanner() {
    final now = DateTime.now();
    if (_lastPressedAt != null &&
        now.difference(_lastPressedAt!) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastPressedAt = now;
    bloc.onAction(const OpenScannerAction());
  }

  @override
  void handleEvent(BuildContext context, HomeEvent event) {
    switch (event) {
      case NavigateToScanner():
        context.pushRoute(const ScannerRoute());
      case ShowSuccessMessage(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: context.appThemes.primaryColor),
        );
      case ShowErrorMessage(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: context.appThemes.errorColor),
        );
      case NavigateToHomeDetail():
      case NavigateBack():
        break;
    }
  }

  DateTime? _lastPopTime;

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) return;

    final now = DateTime.now();
    if (_lastPopTime == null || now.difference(_lastPopTime!) > const Duration(seconds: 2)) {
      _lastPopTime = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.appExitAppConfirm)));
    } else {
      await SystemNavigator.pop();
    }
  }
}
