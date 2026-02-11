// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:transaction/transaction_strings.dart';
import 'package:ui_kit/ui_kit.dart';

class FilterToggleWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  const FilterToggleWidget({
    super.key,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Logic from legacy _buildFilterToggle
    // Using simple/standard UI or copying legacy style if possible
    final backgroundColor = context.appThemes.ink5;

    return Container(
      margin: const .symmetric(horizontal: 20),
      padding: const .all(4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: .circular(12)),
      child: Row(
        children: [
          _buildToggleButton(
            context,
            TransactionStrings.t.received,
            selectedIndex == 0,
            () => onFilterChanged(0),
          ),
          _buildToggleButton(
            context,
            TransactionStrings.t.sent,
            selectedIndex == 1,
            () => onFilterChanged(1),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    String title,
    bool isActive,
    VoidCallback onTap,
  ) {
    final activeColor = context.appThemes.trueBlue;
    final activeTextColor = context.appThemes.white;
    final inactiveTextColor = activeColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const .symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : context.appThemes.transparent,
            borderRadius: .circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: context.appThemes.ink100.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: .center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: .w500,
              color: isActive ? activeTextColor : inactiveTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
