// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import '../../../../core/mixin/safe_call_api_mixin.dart';
import '../models/d3_votion_res_object.dart';
import 'remote/d3_votion_client.dart';

/// ============================================================================
/// D3Votion Remote DataSource
/// ============================================================================
/// Remote datasources handle API calls and network requests.
/// They return data models (not entities).
/// ============================================================================

abstract class D3VotionRemoteDataSource {
  Future<D3VotionResObject> getD3Votion({required String word});
}

@LazySingleton(as: D3VotionRemoteDataSource)
class D3VotionRemoteDataSourceImpl with SafeCallApiMixin implements D3VotionRemoteDataSource {
  final D3VotionClient _client;

  D3VotionRemoteDataSourceImpl(this._client);

  @override
  Future<D3VotionResObject> getD3Votion({required String word}) async {
    return await safeCallApi(
      () => _client.getD3Votion(word),
    );
  }
}
