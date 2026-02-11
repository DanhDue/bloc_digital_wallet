// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:transaction/transaction_strings.dart';
import 'package:ui_kit/ui_kit.dart';

class WalletSelectorWidget extends StatelessWidget {
  const WalletSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: context.appThemes.white,
        border: Border(bottom: BorderSide(color: context.appThemes.ink5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const .all(8),
            decoration: BoxDecoration(
              shape: .circle,
              color: AppColors.materialOrange500.withOpacity(0.1),
            ),
            child: Icon(Icons.currency_bitcoin, color: AppColors.materialOrange500, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  TransactionStrings.t.bitcoinWallet,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w500,
                    color: context.appThemes.ink100,
                  ),
                ),
                Text(
                  "US\$53,727.78 USD",
                  style: TextStyle(fontSize: 14, color: context.appThemes.ink40),
                ),
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: context.appThemes.ink40),
        ],
      ),
    );
  }
}
