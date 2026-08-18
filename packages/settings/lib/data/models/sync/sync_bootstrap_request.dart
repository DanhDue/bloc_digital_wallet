// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings/data/models/sync/cached_translation_item.dart';

part 'sync_bootstrap_request.freezed.dart';
part 'sync_bootstrap_request.g.dart';

@freezed
abstract class SyncBootstrapRequest with _$SyncBootstrapRequest {
  const factory SyncBootstrapRequest({
    @JsonKey(name: 'cached_translations') required List<CachedTranslationItem> cachedTranslations,
  }) = _SyncBootstrapRequest;

  factory SyncBootstrapRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncBootstrapRequestFromJson(json);
}
