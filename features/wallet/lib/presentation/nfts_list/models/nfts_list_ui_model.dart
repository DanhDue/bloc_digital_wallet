// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfts_list_ui_model.freezed.dart';

@freezed
abstract class NftsListUiModel with _$NftsListUiModel {
  const factory NftsListUiModel({@Default('') String title}) = _NftsListUiModel;
}
