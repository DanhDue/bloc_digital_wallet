// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wallet_list_entity.dart';

part 'wallet_list_model.freezed.dart';
part 'wallet_list_model.g.dart';

@freezed
abstract class WalletListModel with _$WalletListModel {
  const factory WalletListModel({
    @JsonKey(name: 'id') required String id,
  }) = _WalletListModel;

  const WalletListModel._();

  factory WalletListModel.fromJson(Map<String, dynamic> json) =>
      _$WalletListModelFromJson(json);

  WalletListEntity toEntity() {
    return WalletListEntity(
      id: id,
    );
  }
}
