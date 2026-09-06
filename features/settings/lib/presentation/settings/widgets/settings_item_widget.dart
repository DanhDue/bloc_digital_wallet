// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings/generated/colors.gen.dart';
import 'package:ui_kit/ui_kit.dart' hide AppColors;

/// The type of trailing widget for a settings item.
enum SettingsItemTrailing { arrow, toggle, value, valueOnly, none }

/// A reusable settings list item with icon, label, and trailing action.
class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    required this.label,
    this.icon,
    this.trailing = SettingsItemTrailing.arrow,
    this.value,
    this.isOn = false,
    this.iconColor,
    this.iconBackgroundColor,
    this.valueColor,
    this.onTap,
    this.onToggle,
    this.showDivider = true,
    super.key,
  });

  final String label;
  final IconData? icon;
  final SettingsItemTrailing trailing;
  final String? value;
  final bool isOn;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color? valueColor;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appThemes = theme.extension<AppThemes>();

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            iconBackgroundColor ??
                            (iconColor ?? appThemes?.primaryColor ?? AppColors.settingsItemBlue)
                                .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: iconColor ?? appThemes?.primaryColor ?? AppColors.settingsItemBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: appThemes?.bodyLarge.copyWith(
                        color: appThemes.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildTrailing(context, appThemes),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: theme.brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : appThemes?.dividerColor,
          ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context, AppThemes? appThemes) {
    switch (trailing) {
      case SettingsItemTrailing.arrow:
        return Icon(Icons.chevron_right, size: 24, color: appThemes?.textSecondaryColor);
      case SettingsItemTrailing.toggle:
        return CupertinoSwitch(
          value: isOn,
          onChanged: onToggle,
          activeTrackColor: appThemes?.primaryColor,
        );
      case SettingsItemTrailing.value:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value ?? '',
              style: appThemes?.bodyMedium.copyWith(
                color: valueColor ?? appThemes.textSecondaryColor,
                fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 24, color: appThemes?.textSecondaryColor),
          ],
        );
      case SettingsItemTrailing.valueOnly:
        return Text(
          value ?? '',
          style: appThemes?.bodyMedium.copyWith(color: appThemes.textSecondaryColor),
        );
      case SettingsItemTrailing.none:
        return const SizedBox.shrink();
    }
  }
}
