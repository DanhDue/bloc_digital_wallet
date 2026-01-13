// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
sealed class TransactionModel with _$TransactionModel {
  const TransactionModel._();

  const factory TransactionModel({
    required String id,
    required String name,
    // TODO: Add your model properties here
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  /// Convert model to entity
  TransactionEntity toEntity() {
    return TransactionEntity(id: id, name: name);
  }

  /// Create model from entity
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(id: entity.id, name: entity.name);
  }
}
