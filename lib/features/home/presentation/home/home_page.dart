// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:bloc_digital_wallet/di/injection.dart';

import '../../../wallet/presentation/wallet/wallet_page.dart';
import '../../../transaction/presentation/transaction/transaction_page.dart';
import '../../../scanner/presentation/scanner/scanner_page.dart';
import '../../../trends/presentation/trends/trends_page.dart';
import '../../../settings/presentation/settings/settings_page.dart';
import 'home_bloc.dart';
import 'home_action.dart';
import 'home_state.dart';
import 'home_event.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Pages for each tab (excluding scanner which is handled by FAB)
  static const List<Widget> _pages = [
    WalletPage(),
    TransactionPage(),
    SizedBox.shrink(), // Placeholder for Scanner (center FAB)
    TrendsPage(),
    SettingsPage(),
  ];

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
          final currentIndex = state.currentTabIndex;

          return Scaffold(
            body: IndexedStack(index: currentIndex, children: _pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<HomeBloc>().onAction(ChangeTabAction(index));
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: context.appThemes.surfaceColor,
              selectedItemColor: context.appThemes.primaryColor,
              unselectedItemColor: context.appThemes.textSecondaryColor,
              selectedLabelStyle: context.appThemes.labelSmall,
              unselectedLabelStyle: context.appThemes.labelSmall,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: const Icon(Icons.account_balance_wallet),
                  label: context.t.navMyWallet,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.language_outlined),
                  activeIcon: const Icon(Icons.language),
                  label: context.t.navTransactions,
                ),
                // Center placeholder for FAB
                const BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.show_chart_outlined),
                  activeIcon: const Icon(Icons.show_chart),
                  label: context.t.navTrends,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_outlined),
                  activeIcon: const Icon(Icons.settings),
                  label: context.t.navSettings,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'home_scanner_fab',
              onPressed: () {
                context.read<HomeBloc>().onAction(const OpenScannerAction());
              },
              backgroundColor: context.appThemes.primaryColor,
              elevation: 4,
              child: Icon(Icons.add, color: context.appThemes.surfaceColor, size: 28),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }
}
