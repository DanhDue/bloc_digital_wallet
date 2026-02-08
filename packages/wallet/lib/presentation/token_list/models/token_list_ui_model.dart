// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_list_ui_model.freezed.dart';

@freezed
abstract class TokenListUiModel with _$TokenListUiModel {
  const factory TokenListUiModel({
    @Default('') String title,
  }) = _TokenListUiModel;
}
