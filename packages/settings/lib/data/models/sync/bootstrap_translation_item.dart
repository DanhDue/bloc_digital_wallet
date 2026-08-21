// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bootstrap_translation_item.freezed.dart';
part 'bootstrap_translation_item.g.dart';

@freezed
abstract class BootstrapTranslationItem with _$BootstrapTranslationItem {
  const factory BootstrapTranslationItem({
    @JsonKey(name: 'resource_id') required String resourceId,
    @JsonKey(name: 'mode') required String mode, // "full" | "delta"
    @JsonKey(name: 'latest_version') required String latestVersion,
    @JsonKey(name: 'fetch_url') String? fetchUrl,
    @JsonKey(name: 'full_fetch_url') String? fullFetchUrl,
    @JsonKey(name: 'delta_available') @Default(false) bool deltaAvailable,
    @JsonKey(name: 'checksum') String? checksum,
    @JsonKey(name: 'deleted_keys') List<String>? deletedKeys,
    @JsonKey(name: 'changes') Map<String, dynamic>? changes,
  }) = _BootstrapTranslationItem;

  factory BootstrapTranslationItem.fromJson(Map<String, dynamic> json) =>
      _$BootstrapTranslationItemFromJson(json);
}
