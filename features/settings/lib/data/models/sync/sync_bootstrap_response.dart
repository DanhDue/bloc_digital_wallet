// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/data/models/sync/bootstrap_translation_item.dart';
import 'package:settings/data/models/sync/bootstrap_user_preferences.dart';
// Note: themes will be added here during Theme phase

part 'sync_bootstrap_response.freezed.dart';
part 'sync_bootstrap_response.g.dart';

@freezed
abstract class SyncBootstrapResponse with _$SyncBootstrapResponse {
  const factory SyncBootstrapResponse({
    @JsonKey(name: 'user_preferences') BootstrapUserPreferences? userPreferences,
    @JsonKey(name: 'stale_translations') List<BootstrapTranslationItem>? translations,
    @JsonKey(name: 'available_languages') List<AvailableLanguage>? availableLanguages,
    @JsonKey(name: 'removed_resources') List<String>? removedResources,
  }) = _SyncBootstrapResponse;

  factory SyncBootstrapResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncBootstrapResponseFromJson(json);
}
