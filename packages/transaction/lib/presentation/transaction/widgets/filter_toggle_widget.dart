// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';

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
    final backgroundColor = const Color(0xFFF5F5F5); // context.appThemes.ink5

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _buildToggleButton(
            context,
            "Received", // Localization needed
            selectedIndex == 0,
            () => onFilterChanged(0),
          ),
          _buildToggleButton(
            context,
            "Sent", // Localization needed
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
    final activeColor = Colors.blue; // context.appThemes.trueBlue
    final activeTextColor = Colors.white; // context.appThemes.white
    final inactiveTextColor = activeColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? activeTextColor : inactiveTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
