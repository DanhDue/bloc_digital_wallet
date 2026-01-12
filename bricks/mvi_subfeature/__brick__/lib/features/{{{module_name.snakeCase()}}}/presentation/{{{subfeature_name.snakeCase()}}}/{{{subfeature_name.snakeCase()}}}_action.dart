// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';
import '{{{subfeature_name.snakeCase()}}}_intent.dart';

sealed class {{subfeature_name.pascalCase()}}Action extends MviAction {
  const {{subfeature_name.pascalCase()}}Action();
}

class Load{{subfeature_name.pascalCase()}}Action extends {{subfeature_name.pascalCase()}}Action {
  const Load{{subfeature_name.pascalCase()}}Action();
}
