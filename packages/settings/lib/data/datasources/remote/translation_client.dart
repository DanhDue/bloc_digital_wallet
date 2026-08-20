// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'translation_client.g.dart';

@RestApi()
abstract class TranslationClient {
  factory TranslationClient(Dio dio, {String? baseUrl}) = _TranslationClient;

  @GET('/{languageCode}')
  Future<dynamic> getLocalizationOverrides(
    @Path('languageCode') String languageCode, {
    @Query('since_version') String? sinceVersion,
  });
}
