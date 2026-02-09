// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onTap;

  const TransactionItemWidget({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Logic from legacy view
    final isReceived = (transaction.overview?.slot ?? 0) % 2 == 0;
    final dateStr = transaction.overview?.timestamp?.yMMMMd ?? "Jun 28, 2021";
    final amountUsd = isReceived ? "US\$694.69" : "US\$320.00";
    final amountCrypto = isReceived ? "0.021BTC" : "0.010BTC";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white, // context.appThemes.white
          border: Border(
            bottom: BorderSide(color: Color(0xFFF5F5F5)), // context.appThemes.ink5
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isReceived ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD),
              ),
              child: Icon(
                isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                color: isReceived ? const Color(0xFF4CAF50) : const Color(0xFF2196F3),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isReceived
                        ? "Received BTC" // Localization needed
                        : "Sent BTC",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87, // context.appThemes.ink100
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54, // context.appThemes.ink40
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountUsd,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(amountCrypto, style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
