// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:{{name.snakeCase()}}/{{name.snakeCase()}}.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('{{name.pascalCase()}} plugin initialized', () {
{{#has_ui}}
    const widget = {{name.pascalCase()}}NativeView();
    expect(widget, isNotNull);
{{/has_ui}}
{{^has_ui}}
    final api = {{name.pascalCase()}}HostApi();
    expect(api, isNotNull);
{{/has_ui}}
  });
}
