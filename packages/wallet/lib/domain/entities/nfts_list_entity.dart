// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfts_list_entity.freezed.dart';

@freezed
abstract class NftsListEntity with _$NftsListEntity {
  const NftsListEntity._();

  const factory NftsListEntity({required String id}) = _NftsListEntity;
}
