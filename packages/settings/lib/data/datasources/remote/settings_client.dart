// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:settings/data/models/settings_model.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/data/datasources/remote/settings_uri.dart';

part 'settings_client.g.dart';

@RestApi()
abstract class SettingsClient {
  factory SettingsClient(Dio dio, {String? baseUrl}) = _SettingsClient;

  @GET('')
  Future<SettingsModel> getSettings();

  @POST(SettingsUri.bootstrap)
  Future<SyncBootstrapResponse> bootstrap(@Body() SyncBootstrapRequest request);
}
