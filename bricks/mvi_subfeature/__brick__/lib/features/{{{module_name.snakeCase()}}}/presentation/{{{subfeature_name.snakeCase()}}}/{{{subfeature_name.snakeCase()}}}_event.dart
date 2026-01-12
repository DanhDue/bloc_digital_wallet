// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

sealed class {{subfeature_name.pascalCase()}}Event extends BaseEvent {
  const {{subfeature_name.pascalCase()}}Event();
}

class Show{{subfeature_name.pascalCase()}}SuccessMessage extends {{subfeature_name.pascalCase()}}Event {
  final String message;
  const Show{{subfeature_name.pascalCase()}}SuccessMessage(this.message);
}

class Show{{subfeature_name.pascalCase()}}ErrorMessage extends {{subfeature_name.pascalCase()}}Event {
  final String message;
  const Show{{subfeature_name.pascalCase()}}ErrorMessage(this.message);
}
