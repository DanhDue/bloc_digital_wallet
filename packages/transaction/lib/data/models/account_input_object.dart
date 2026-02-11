// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:transaction/domain/entities/account_input_entity.dart';

part 'account_input_object.freezed.dart';
part 'account_input_object.g.dart';

@freezed
abstract class AccountInputObject with _$AccountInputObject {
  const AccountInputObject._();

  @JsonSerializable(includeIfNull: false)
  const factory AccountInputObject({
    @JsonKey(name: 'is_payer') bool? isPayer,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'changes') int? changes,
    @JsonKey(name: 'post_balance') double? postBalance,
    @JsonKey(name: 'details') List<String>? details,
  }) = _AccountInputObject;

  factory AccountInputObject.fromJson(Map<String, dynamic> json) =>
      _$AccountInputObjectFromJson(json);

  AccountInputEntity toEntity() => AccountInputEntity(
    isPayer: isPayer,
    address: address,
    changes: changes,
    postBalance: postBalance,
    details: details,
  );
}
