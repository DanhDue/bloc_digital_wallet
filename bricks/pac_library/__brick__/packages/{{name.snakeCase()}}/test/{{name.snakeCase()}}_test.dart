// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

{{#is_flutter}}
import 'package:flutter_test/flutter_test.dart';
{{/is_flutter}}
{{^is_flutter}}
import 'package:test/test.dart';
{{/is_flutter}}
import 'package:{{name.snakeCase()}}/{{name.snakeCase()}}.dart';

void main() {
  group('{{name.pascalCase()}} Tests', () {
    test('isAvailable returns true', () {
      const instance = {{name.pascalCase()}}();
      expect(instance.isAvailable(), isTrue);
    });
  });
}
