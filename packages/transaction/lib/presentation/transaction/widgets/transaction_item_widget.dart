// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';
import 'package:transaction/transaction_strings.dart';
import 'package:ui_kit/ui_kit.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionEntity transaction;
  final bool isLast;
  final bool isReceived;
  final String formattedTime;
  final String formattedAmount;
  final String formattedFiatAmount;
  final VoidCallback? onTap;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    this.isLast = false,
    required this.isReceived,
    required this.formattedTime,
    required this.formattedAmount,
    required this.formattedFiatAmount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: context.appThemes.white,
          border: isLast ? null : Border(bottom: BorderSide(color: context.appThemes.ink5)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: .circle,
                color: isReceived ? AppColors.materialGreen50 : AppColors.materialBlue50,
              ),
              child: Icon(
                isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                color: isReceived ? AppColors.materialGreen500 : AppColors.materialBlue500,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    isReceived
                        ? TransactionStrings.t.transaction.bitcoin.received
                        : TransactionStrings.t.transaction.bitcoin.sent,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: .w600,
                      color: context.appThemes.ink100,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(fontSize: 14, color: context.appThemes.ink40),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: .end,
              children: [
                Text(
                  formattedFiatAmount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .bold,
                    color: context.appThemes.ink100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedAmount,
                  style: TextStyle(fontSize: 12, color: context.appThemes.ink40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
