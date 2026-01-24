// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';

void main() {
  group('D3VotionResObject', () {
    test('fromJson parses correctly', () {
      final jsonString = '''
      {
        "word": "single",
        "definition": "One only; not accompanied by others or combined with anything else; unmarried.",
        "ipa": "/ˈsɪŋɡl/",
        "samples": [
          {
            "text": "I would like a single room for the night, please.",
            "vietnamese_text": "Làm ơn cho tôi một phòng đơn cho đêm nay.",
            "audio_link": "https://translate.google.com/translate_tts?ie=UTF-8&q=I%20would%20like%20a%20single%20room%20for%20the%20night%2C%20please.&tl=en&client=tw-ob"
          }
        ]
      }
      ''';

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final model = D3VotionResObject.fromJson(jsonMap);

      expect(model.word, 'single');
      expect(model.definition, 'One only; not accompanied by others or combined with anything else; unmarried.');
      expect(model.ipa, '/ˈsɪŋɡl/');
      expect(model.samples, hasLength(1));
      expect(model.samples!.first.text, 'I would like a single room for the night, please.');
      expect(model.samples!.first.vietnameseText, 'Làm ơn cho tôi một phòng đơn cho đêm nay.');
      expect(model.samples!.first.audioLink, 'https://translate.google.com/translate_tts?ie=UTF-8&q=I%20would%20like%20a%20single%20room%20for%20the%20night%2C%20please.&tl=en&client=tw-ob');
    });
  });
}
