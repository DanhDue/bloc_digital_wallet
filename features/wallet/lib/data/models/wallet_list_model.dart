// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/domain/entities/wallet_list_entity.dart';
import 'package:wallet/data/models/wallet_model.dart';

part 'wallet_list_model.freezed.dart';
part 'wallet_list_model.g.dart';

@freezed
abstract class WalletListModel with _$WalletListModel {
  const WalletListModel._();

  @JsonSerializable(includeIfNull: false)
  const factory WalletListModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'wallets') @Default([]) List<WalletModel> wallets,
  }) = _WalletListModel;

  factory WalletListModel.fromJson(Map<String, dynamic> json) => _$WalletListModelFromJson(json);

  WalletListEntity toEntity() {
    return WalletListEntity(id: id, wallets: wallets.map((e) => e.toEntity()).toList());
  }
}
