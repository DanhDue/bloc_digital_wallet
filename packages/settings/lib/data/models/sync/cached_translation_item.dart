// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cached_translation_item.freezed.dart';
part 'cached_translation_item.g.dart';

@freezed
abstract class CachedTranslationItem with _$CachedTranslationItem {
  const factory CachedTranslationItem({
    @JsonKey(name: 'resource_id') required String resourceId,
    @JsonKey(name: 'version') required String version,
  }) = _CachedTranslationItem;

  factory CachedTranslationItem.fromJson(Map<String, dynamic> json) =>
      _$CachedTranslationItemFromJson(json);
}
