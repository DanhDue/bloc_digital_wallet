import 'package:bloc_digital_wallet/generated/translations.dart' as root;

void main() {
  final code = 'ko_KR';
  final locale = root.AppLocaleUtils.parse(code);
  print('Parsed $code as ${locale.languageCode}');
}
