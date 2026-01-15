// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_action.dart';
import 'home_bloc.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({required this.tabsRouter, super.key});

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    // Map router index (0,1,2,3) to bottom nav index (0,1,3,4)
    final bottomNavIndex = tabsRouter.activeIndex > 1
        ? tabsRouter.activeIndex + 1
        : tabsRouter.activeIndex;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: BottomNavigationBar(
        currentIndex: bottomNavIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) {
            context.read<HomeBloc>().onAction(const OpenScannerAction());
            return;
          }

          context.read<HomeBloc>().onAction(ChangeTabAction(index));

          // Map bottom nav index (0,1,3,4) back to router index (0,1,2,3)
          final routerIndex = index > 2 ? index - 1 : index;
          tabsRouter.setActiveIndex(routerIndex);
        },
        type: .fixed,
        backgroundColor: context.appThemes.surfaceColor,
        selectedItemColor: context.appThemes.primaryColor,
        unselectedItemColor: context.appThemes.textSecondaryColor,
        selectedLabelStyle: context.appThemes.labelSmall,
        unselectedLabelStyle: context.appThemes.labelSmall,
        items: [
          _buildBottomNavItem(
            context,
            Assets.images.icWalletLine.svg(
              colorFilter: .mode(context.appThemes.textSecondaryColor, .srcIn),
            ),
            Assets.images.icWalletLine.svg(
              colorFilter: .mode(context.appThemes.trueBlue100, .srcIn),
            ),
            context.t.navMyWallet,
          ),
          _buildBottomNavItem(
            context,
            Assets.images.icGlobe.svg(
              colorFilter: .mode(context.appThemes.textSecondaryColor, .srcIn),
            ),
            Assets.images.icGlobe.svg(colorFilter: .mode(context.appThemes.trueBlue100, .srcIn)),
            context.t.navTransactions,
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: context.appThemes.trueBlue100,
                  shape: .circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.appThemes.trueBlue100.withValues(alpha: 0.35),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(Icons.qr_code_scanner, color: context.appThemes.trueBlue0, size: 28),
              ),
            ),
            label: '',
          ),
          _buildBottomNavItem(
            context,
            Assets.images.icMarket.svg(
              colorFilter: .mode(context.appThemes.textSecondaryColor, .srcIn),
            ),
            Assets.images.icMarket.svg(colorFilter: .mode(context.appThemes.trueBlue100, .srcIn)),
            context.t.navTrends,
          ),
          _buildBottomNavItem(
            context,
            Assets.images.icSettingsLine.svg(
              colorFilter: .mode(context.appThemes.textSecondaryColor, .srcIn),
            ),
            Assets.images.icSettingsLine.svg(
              colorFilter: .mode(context.appThemes.trueBlue100, .srcIn),
            ),
            context.t.navSettings,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    BuildContext context,
    Widget icon,
    Widget activeIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const .only(top: 8.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            icon,
            Text(
              label,
              style: context.appThemes.labelSmall.copyWith(
                color: context.appThemes.textSecondaryColor,
              ),
            ),
            Opacity(
              opacity: 0,
              child: Assets.images.icSelectedBotTabIndicator.image(fit: .contain),
            ),
          ],
        ),
      ),
      activeIcon: Padding(
        padding: const .only(top: 8.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            activeIcon,
            Text(
              label,
              style: context.appThemes.labelSmall.copyWith(color: context.appThemes.primaryColor),
            ),
            Assets.images.icSelectedBotTabIndicator.image(fit: .contain),
          ],
        ),
      ),
      label: label,
    );
  }
}
