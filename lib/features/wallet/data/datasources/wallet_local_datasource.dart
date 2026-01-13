// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/wallet_model.dart';

abstract class WalletLocalDataSource {
  Future<void> cacheWallet(WalletModel model);
  Future<WalletModel?> getCachedWallet(String id);
  Future<List<WalletModel>> getAllCachedWallets();
  Future<void> clearCache();
}

@LazySingleton(as: WalletLocalDataSource)
class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  // TODO: Inject Hive, SharedPreferences, or SecureStorage
  // final Box<WalletModel> box;

  // const WalletLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheWallet(WalletModel model) async {
    // TODO: Implement caching
    throw UnimplementedError();
  }

  @override
  Future<WalletModel?> getCachedWallet(String id) async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<WalletModel>> getAllCachedWallets() async {
    // TODO: Implement cache retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
