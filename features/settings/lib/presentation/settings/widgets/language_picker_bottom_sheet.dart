// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/generated/colors.gen.dart';

class LanguagePickerBottomSheet extends StatelessWidget {
  final List<SupportedLanguage> languages;
  final String currentLanguageCode;
  final ValueChanged<String> onLanguageSelected;
  final String title;

  const LanguagePickerBottomSheet({
    super.key,
    required this.languages,
    required this.currentLanguageCode,
    required this.onLanguageSelected,
    required this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SupportedLanguage> languages,
    required String currentLanguageCode,
    required ValueChanged<String> onLanguageSelected,
    required String title,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LanguagePickerBottomSheet(
        languages: languages,
        currentLanguageCode: currentLanguageCode,
        onLanguageSelected: onLanguageSelected,
        title: title,
      ),
    );
  }

  static String resolveNativeLanguageName(String code, String fallbackName) {
    final cleanCode = code.toLowerCase().split(RegExp(r'[-_]')).first;
    switch (cleanCode) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      default:
        return fallbackName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBase = currentLanguageCode.toLowerCase().split(RegExp(r'[-_]')).first;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ...languages.map((lang) {
            final langBase = lang.languageCode.toLowerCase().split(RegExp(r'[-_]')).first;
            final isSelected = langBase == currentBase;

            return ListTile(
              key: ValueKey('language_option_$langBase'),
              title: Text(resolveNativeLanguageName(lang.languageCode, lang.languageName)),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.settingsItemBlue)
                  : null,
              onTap: () {
                onLanguageSelected(lang.languageCode);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
