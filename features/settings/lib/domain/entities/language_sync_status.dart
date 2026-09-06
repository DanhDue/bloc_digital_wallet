// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

sealed class LanguageSyncStatus extends Equatable {
  const LanguageSyncStatus();

  const factory LanguageSyncStatus.idle() = LanguageSyncIdle;
  const factory LanguageSyncStatus.loading(String languageCode) = LanguageSyncLoading;
  const factory LanguageSyncStatus.cachedApplied(String languageCode) = LanguageSyncCachedApplied;
  const factory LanguageSyncStatus.success(String languageCode) = LanguageSyncSuccess;
  const factory LanguageSyncStatus.error(String languageCode, String message) = LanguageSyncError;
}

class LanguageSyncIdle extends LanguageSyncStatus {
  const LanguageSyncIdle();

  @override
  List<Object?> get props => [];
}

class LanguageSyncLoading extends LanguageSyncStatus {
  final String languageCode;
  const LanguageSyncLoading(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageSyncCachedApplied extends LanguageSyncStatus {
  final String languageCode;
  const LanguageSyncCachedApplied(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageSyncSuccess extends LanguageSyncStatus {
  final String languageCode;
  const LanguageSyncSuccess(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageSyncError extends LanguageSyncStatus {
  final String languageCode;
  final String message;
  const LanguageSyncError(this.languageCode, this.message);

  @override
  List<Object?> get props => [languageCode, message];
}
