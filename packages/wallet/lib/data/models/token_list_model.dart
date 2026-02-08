// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/token_list_entity.dart';

part 'token_list_model.freezed.dart';
part 'token_list_model.g.dart';

@freezed
abstract class TokenListModel with _$TokenListModel {
  const factory TokenListModel({@JsonKey(name: 'id') required String id}) = _TokenListModel;

  const TokenListModel._();

  factory TokenListModel.fromJson(Map<String, dynamic> json) => _$TokenListModelFromJson(json);

  TokenListEntity toEntity() {
    return TokenListEntity(id: id);
  }
}
