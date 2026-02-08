// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:transaction/data/models/transaction_model.dart';

part 'transaction_client.g.dart';

@RestApi()
abstract class TransactionClient {
  factory TransactionClient(Dio dio, {String? baseUrl}) = _TransactionClient;

  @GET('/transaction')
  Future<TransactionModel> getTransaction();
}
