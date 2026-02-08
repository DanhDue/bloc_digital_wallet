// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:transaction/data/datasources/remote/transaction_client.dart';

@module
abstract class TransactionNetworkModule {
  @lazySingleton
  TransactionClient transactionClient(Dio dio) => TransactionClient(dio);
}
