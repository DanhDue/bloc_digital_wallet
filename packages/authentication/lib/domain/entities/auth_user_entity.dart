// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_entity.freezed.dart';

/// ============================================================================
/// AuthUser Entity
/// ============================================================================
/// Entities are pure Dart classes representing business objects.
/// They should NOT have any Flutter or external dependencies.
///
/// Migrated from Equatable to Freezed for consistency with other entities.
/// ============================================================================

@freezed
abstract class AuthUserEntity with _$AuthUserEntity {
  const AuthUserEntity._();

  const factory AuthUserEntity({
    required String id,
    required String email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) = _AuthUserEntity;
}
