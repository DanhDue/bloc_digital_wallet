// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'models/nfts_list_ui_model.dart';

part 'nfts_list_state.freezed.dart';

enum NftsListStatus { initial, loading, success, failure }

@freezed
abstract class NftsListState extends BaseState with _$NftsListState {
  const factory NftsListState({
    @Default(NftsListStatus.initial) NftsListStatus status,
    @Default(NftsListUiModel()) NftsListUiModel uiModel,
    String? errorMessage,
  }) = _NftsListState;

  const NftsListState._();
}
