// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:network/base_response_object.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/data/models/network_selection_model.dart';
import 'package:wallet/data/models/nfts_list_model.dart';
import 'package:wallet/data/models/wallet_list_model.dart';
import 'package:wallet/data/models/wallet_model.dart';

part 'wallet_client.g.dart';

@RestApi()
abstract class WalletClient {
  factory WalletClient(Dio dio, {String? baseUrl}) = _WalletClient;

  @GET('')
  Future<WalletModel> getWallet();

  @GET('/network_selection')
  Future<BaseResponseObject<NetworkSelectionModel>> getNetworkSelection();

  @GET('/nfts_list')
  Future<BaseResponseObject<NftsListModel>> getNftsList();

  @GET('/wallet_list')
  Future<BaseResponseObject<WalletListModel>> getWalletList();
}
