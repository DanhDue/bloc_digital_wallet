// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/models/wallet_list_model.dart';
import 'package:wallet/data/models/wallet_model.dart';

@lazySingleton
class WalletLocalDataSource {
  Future<WalletListModel> getWalletList() async {
    final String response = await rootBundle.loadString(
      'packages/wallet/assets/jsons/test_wallets.json',
    );
    final List<dynamic> data = jsonDecode(response);

    final wallets = data.map((e) => WalletModel.fromJson(e as Map<String, dynamic>)).toList();

    return WalletListModel(id: 'local_wallet_list', wallets: wallets);
  }
}
