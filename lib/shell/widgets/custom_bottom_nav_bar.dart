// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:ui_kit/ui_kit.dart';

/// Tab index constants for the bottom navigation bar.
class ShellTabIndex {
  const ShellTabIndex._();

  static const int home = 0;
  static const int scanner = 1;
  static const int settings = 2;
}

/// Custom bottom navigation bar with an elevated center QR Scanner button.
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
          padding: const EdgeInsets.only(top: 3, bottom: 6),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == ShellTabIndex.home,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(ShellTabIndex.home),
                onDoubleTap: () => onDoubleTap?.call(ShellTabIndex.home),
              ),
              _CenterNavItem(
                icon: Icons.qr_code_scanner,
                isActive: currentIndex == ShellTabIndex.scanner,
                activeColor: activeColor,
                onTap: () => onTap(ShellTabIndex.scanner),
                onDoubleTap: () => onDoubleTap?.call(ShellTabIndex.scanner),
              ),
              _NavItem(
                key: const ValueKey('settings_nav_tab'),
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: context.t.home.nav.settings,
                isActive: currentIndex == ShellTabIndex.settings,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(ShellTabIndex.settings),
                onDoubleTap: () => onDoubleTap?.call(ShellTabIndex.settings),
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
    super.key,
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
