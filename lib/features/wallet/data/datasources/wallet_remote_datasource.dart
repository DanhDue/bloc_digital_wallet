// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';
import '../models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet(String id);
  Future<List<WalletModel>> getAllWallets();
  Future<WalletModel> createWallet(WalletModel model);
  Future<WalletModel> updateWallet(WalletModel model);
  Future<void> deleteWallet(String id);
}

@LazySingleton(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  // TODO: Inject Dio or Retrofit API client
  // final WalletApiClient apiClient;

  // const WalletRemoteDataSourceImpl(this.apiClient);

  @override
  Future<WalletModel> getWallet(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<WalletModel>> getAllWallets() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<WalletModel> createWallet(WalletModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<WalletModel> updateWallet(WalletModel model) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWallet(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
