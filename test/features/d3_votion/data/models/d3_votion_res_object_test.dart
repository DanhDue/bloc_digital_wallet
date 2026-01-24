import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/sample.dart';

void main() {
  const jsonString = '''
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

  test('should parse D3VotionResObject from JSON', () {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final result = D3VotionResObject.fromJson(jsonMap);

    expect(result.word, 'single');
    expect(result.definition, 'One only; not accompanied by others or combined with anything else; unmarried.');
    expect(result.ipa, '/ˈsɪŋɡl/');
    expect(result.samples?.length, 1);
    expect(result.samples?.first.text, 'I would like a single room for the night, please.');
    expect(result.samples?.first.vietnameseText, 'Làm ơn cho tôi một phòng đơn cho đêm nay.');
    expect(result.samples?.first.audioLink, 'https://translate.google.com/translate_tts?ie=UTF-8&q=I%20would%20like%20a%20single%20room%20for%20the%20night%2C%20please.&tl=en&client=tw-ob');
  });
}
