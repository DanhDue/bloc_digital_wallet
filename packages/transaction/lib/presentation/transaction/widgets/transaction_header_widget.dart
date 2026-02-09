// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';

class TransactionHeaderWidget extends StatelessWidget {
  final String title;

  const TransactionHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54, // context.appThemes.ink40
        ),
      ),
    );
  }
}
