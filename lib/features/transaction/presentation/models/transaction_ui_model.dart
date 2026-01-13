// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_ui_model.freezed.dart';
part 'transaction_ui_model.g.dart';

@freezed
sealed class TransactionUiModel with _$TransactionUiModel {
  const factory TransactionUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _TransactionUiModel;

  factory TransactionUiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionUiModelFromJson(json);
}
