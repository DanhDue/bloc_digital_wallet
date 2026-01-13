// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_ui_model.freezed.dart';
part 'wallet_ui_model.g.dart';

@freezed
sealed class WalletUiModel with _$WalletUiModel {
  const factory WalletUiModel({
    required String id,
    required String name,
    // TODO: Add UI properties
  }) = _WalletUiModel;

  factory WalletUiModel.fromJson(Map<String, dynamic> json) => _$WalletUiModelFromJson(json);
}
