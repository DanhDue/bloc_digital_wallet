// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/presentation/settings/widgets/language_picker_bottom_sheet.dart';

void main() {
  testWidgets('LanguagePickerBottomSheet renders native language names and checkmark', (tester) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                LanguagePickerBottomSheet.show(
                  context,
                  languages: const [
                    SupportedLanguage(languageCode: 'en', languageName: 'English'),
                    SupportedLanguage(languageCode: 'vi', languageName: 'Vietnamese'),
                    SupportedLanguage(languageCode: 'ja', languageName: 'Japanese'),
                  ],
                  currentLanguageCode: 'vi',
                  title: 'Select Language',
                  onLanguageSelected: (code) => selected = code,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();

    expect(selected, equals('ja'));
  });

  test('resolveNativeLanguageName maps known codes to native names', () {
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('en', 'Fallback'), equals('English'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('vi', 'Fallback'), equals('Tiếng Việt'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('ja', 'Fallback'), equals('日本語'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('ko', 'Fallback'), equals('한국어'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('zh', 'Fallback'), equals('中文'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('fr', 'Fallback'), equals('Français'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('de', 'Fallback'), equals('Deutsch'));
    expect(LanguagePickerBottomSheet.resolveNativeLanguageName('es', 'Spanish'), equals('Spanish'));
  });
}
