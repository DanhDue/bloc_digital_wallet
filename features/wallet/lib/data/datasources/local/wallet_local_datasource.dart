// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/models/wallet_list_model.dart';
import 'package:wallet/data/models/wallet_model.dart';

@lazySingleton
class WalletLocalDataSource {
  static const _walletListAssetPath = 'packages/wallet/assets/jsons/test_wallets.json';
  static const _localWalletListId = 'local_wallet_list';

  Future<WalletListModel> getWalletList() async {
    try {
      final String response = await rootBundle.loadString(_walletListAssetPath);
      final List<dynamic> data = jsonDecode(response);

      final wallets = data.map((e) {
        if (e is Map<String, dynamic>) {
          return WalletModel.fromJson(e);
        }
        throw const FormatException('Invalid wallet format');
      }).toList();

      return WalletListModel(id: _localWalletListId, wallets: wallets);
    } catch (e) {
      // In a real app, we might want to throw a custom Failure here
      // For now, rethrowing or returning an empty list based on requirements.
      // Given the signature returns a Model, we throw.
      throw Exception('Failed to load local wallet list: $e');
    }
  }
}
