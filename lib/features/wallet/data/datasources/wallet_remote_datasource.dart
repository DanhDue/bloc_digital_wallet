// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/mixin/safe_call_api_mixin.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/wallet/data/datasources/remote/token_client.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/token_account_object.dart';

abstract class WalletRemoteDataSource {
  Future<Either<Failure, BaseResponseObject<List<TokenAccountObject>>>> getTokenAccounts({
    required String address,
  });
}

@LazySingleton(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl with SafeCallApiMixin implements WalletRemoteDataSource {
  final TokenClient _tokenClient;

  WalletRemoteDataSourceImpl(this._tokenClient);

  @override
  Future<Either<Failure, BaseResponseObject<List<TokenAccountObject>>>> getTokenAccounts({
    required String address,
  }) => safeApiCall(() => _tokenClient.getTokenAccounts(address));
}
