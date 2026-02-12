// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:home/generated/translations.dart';
import 'package:ui_kit/ui_kit.dart';

/// Tab index constants for the bottom navigation bar.
class HomeTabIndex {
  const HomeTabIndex._();

  static const int wallet = 0;
  static const int browser = 1;
  static const int qrScanner = 2;
  static const int trends = 3;
  static const int settings = 4;
}

/// Custom bottom navigation bar with an elevated center QR Scanner button.
///
/// Migrated from the old `CustomBotNavBar` (GetX) to work with BLoC.
/// Uses [GestureDetector] for tap and double-tap support on each item.
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onDoubleTap,
  });

  final int currentIndex;
  final void Function(int) onTap;
  final void Function(int)? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.appThemes.trueBlue;
    final inactiveColor = context.appThemes.ink40;
    final backgroundColor = context.appThemes.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: context.appThemes.ink40.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: context.tHome.home.nav.wallet,
                isActive: currentIndex == HomeTabIndex.wallet,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(HomeTabIndex.wallet),
                onDoubleTap: () => onDoubleTap?.call(HomeTabIndex.wallet),
              ),
              _NavItem(
                icon: Icons.language_outlined,
                activeIcon: Icons.language,
                label: context.tHome.home.nav.browser,
                isActive: currentIndex == HomeTabIndex.browser,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(HomeTabIndex.browser),
                onDoubleTap: () => onDoubleTap?.call(HomeTabIndex.browser),
              ),
              _CenterNavItem(
                icon: Icons.qr_code_scanner,
                isActive: currentIndex == HomeTabIndex.qrScanner,
                activeColor: activeColor,
                onTap: () => onTap(HomeTabIndex.qrScanner),
                onDoubleTap: () => onDoubleTap?.call(HomeTabIndex.qrScanner),
              ),
              _NavItem(
                icon: Icons.trending_up_outlined,
                activeIcon: Icons.trending_up,
                label: context.tHome.home.nav.trends,
                isActive: currentIndex == HomeTabIndex.trends,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(HomeTabIndex.trends),
                onDoubleTap: () => onDoubleTap?.call(HomeTabIndex.trends),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: context.tHome.home.nav.settings,
                isActive: currentIndex == HomeTabIndex.settings,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(HomeTabIndex.settings),
                onDoubleTap: () => onDoubleTap?.call(HomeTabIndex.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Regular navigation item with icon and label.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
    this.onDoubleTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        behavior: .opaque,
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.appThemes.labelSmall.copyWith(
                color: color,
                fontWeight: isActive ? .w700 : .w400,
              ),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Elevated center navigation item (QR Scanner button).
class _CenterNavItem extends StatelessWidget {
  const _CenterNavItem({
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
    this.onDoubleTap,
  });

  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: activeColor,
            shape: .circle,
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: context.appThemes.white, size: 28),
        ),
      ),
    );
  }
}
