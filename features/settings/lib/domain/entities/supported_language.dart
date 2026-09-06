// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

class SupportedLanguage extends Equatable {
  final String languageCode;
  final String languageName;
  final String? version;
  final bool isDefault;
  final bool isActive;
  final bool isCached;

  const SupportedLanguage({
    required this.languageCode,
    required this.languageName,
    this.version,
    this.isDefault = false,
    this.isActive = true,
    this.isCached = false,
  });

  SupportedLanguage copyWith({
    String? languageCode,
    String? languageName,
    String? version,
    bool? isDefault,
    bool? isActive,
    bool? isCached,
  }) {
    return SupportedLanguage(
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
      version: version ?? this.version,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      isCached: isCached ?? this.isCached,
    );
  }

  @override
  List<Object?> get props => [
        languageCode,
        languageName,
        version,
        isDefault,
        isActive,
        isCached,
      ];
}
