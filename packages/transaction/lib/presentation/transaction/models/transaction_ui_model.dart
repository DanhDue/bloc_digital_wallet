// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/domain/entities/transaction_entity.dart';

part 'transaction_ui_model.freezed.dart';

@freezed
abstract class TransactionUiModel with _$TransactionUiModel {
  const factory TransactionUiModel({
    required String id,
    required String name,
    String? description,
  }) = _TransactionUiModel;

  factory TransactionUiModel.fromEntity(TransactionEntity entity) {
    return TransactionUiModel(id: entity.id, name: entity.name, description: entity.description);
  }
}
