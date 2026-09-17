// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../models/token_list_ui_model.dart';

/// Token item view widget for displaying token info in a list
class TokenItemView extends StatelessWidget {
  final TokenListUiModel token;
  final bool isFirst;
  final VoidCallback? onTap;

  const TokenItemView({super.key, required this.token, this.isFirst = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => debugPrint('Token tapped: ${token.name}'),
      child: Padding(
        padding: const .only(top: 8),
        child: Row(
          children: [
            // Token Logo
            _buildTokenLogo(context),
            const SizedBox(width: 12),

            // Name and Percentage
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    token.name,
                    style: context.appThemes.titleMedium.copyWith(fontWeight: .w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    token.formattedPercentChange,
                    style: context.appThemes.bodySmall.copyWith(
                      color: token.isPositiveChange
                          ? context.appThemes.trendUpColor
                          : context.appThemes.errorColor,
                    ),
                  ),
                ],
              ),
            ),

            // Balance
            Column(
              crossAxisAlignment: .end,
              mainAxisSize: .min,
              children: [
                Text(
                  token.formattedBalance,
                  style: context.appThemes.titleMedium.copyWith(fontWeight: .w500),
                ),
                const SizedBox(height: 2),
                Text(
                  token.formattedFiatBalance,
                  style: context.appThemes.bodySmall.copyWith(color: context.appThemes.ink40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenLogo(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: ClipRRect(
        borderRadius: .circular(100),
        child: token.imageUrl.isNotEmpty
            ? Image.network(
                token.imageUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(context),
              )
            : _buildPlaceholderIcon(context),
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Container(
      color: context.appThemes.ink10,
      child: Icon(Icons.token, size: 20, color: context.appThemes.ink40),
    );
  }
}
