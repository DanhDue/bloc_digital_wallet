// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_input_entity.freezed.dart';

@freezed
abstract class AccountInputEntity with _$AccountInputEntity {
  const AccountInputEntity._();

  const factory AccountInputEntity({
    bool? isPayer,
    String? address,
    int? changes,
    double? postBalance,
    List<String>? details,
  }) = _AccountInputEntity;
}
