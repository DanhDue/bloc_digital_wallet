// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:network/base_response_object.dart';
import 'package:transaction/data/datasources/remote/transaction_uri.dart';
import 'package:retrofit/retrofit.dart';
import 'package:transaction/data/models/transaction_response_object.dart';

part 'transaction_client.g.dart';

@RestApi()
abstract class TransactionClient {
  factory TransactionClient(Dio dio, {String baseUrl}) = _TransactionClient;

  @GET(TransactionUri.pathSignature)
  Future<BaseResponseObject<TransactionResponseObject?>?> getTransactionBySignature(
    @Path("signature") String signature,
    @Query("parsed_json") bool? parsedJson,
    @Query("owners") List<String>? owners,
  );

  @GET("")
  Future<BaseResponseObject<List<TransactionResponseObject?>?>?> getTransactionByOwner(
    @Query("owner") String owner,
    @Query("limit") int? limit,
    @Query("before") String? before,
    @Query("until") String? until,
  );
}
