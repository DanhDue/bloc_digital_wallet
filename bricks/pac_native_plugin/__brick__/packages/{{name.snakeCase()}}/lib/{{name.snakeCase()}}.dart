// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

{{#has_ui}}
export 'src/ui/{{name.snakeCase()}}_native_view.dart';
{{/has_ui}}
{{^has_ui}}
export 'src/messages.g.dart';
{{/has_ui}}
