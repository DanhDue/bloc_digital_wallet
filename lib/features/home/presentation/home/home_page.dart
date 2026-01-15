// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/features/home/presentation/home/home_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../scanner/presentation/scanner/scanner_page.dart';

import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          // Listen to events
          context.read<HomeBloc>().events.listen((event) {
            if (!context.mounted) return;
            switch (event) {
              case NavigateToScanner():
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => const ScannerPage()));
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: context.appThemes.primaryColor,
                  ),
                );
              case ShowErrorMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: context.appThemes.errorColor),
                );
              case NavigateToHomeDetail():
              case NavigateBack():
                break;
            }
          });
        },
        builder: (context, state) {
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
                  bottomNavigationBar: HomeBottomNavigationBar(tabsRouter: tabsRouter),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) return;

    final now = DateTime.now();
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.appExitAppConfirm)));
    } else {
      await SystemNavigator.pop();
    }
  }
}
