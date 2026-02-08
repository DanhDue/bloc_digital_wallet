// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

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
        padding: const EdgeInsets.only(top: 8),
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
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    token.formattedPercentChange,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: token.isPositiveChange ? Colors.green : Colors.red,
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  token.formattedFiatBalance,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor),
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
        borderRadius: BorderRadius.circular(100),
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
      color: Theme.of(context).dividerColor,
      child: Icon(Icons.token, size: 20, color: Theme.of(context).disabledColor),
    );
  }
}
