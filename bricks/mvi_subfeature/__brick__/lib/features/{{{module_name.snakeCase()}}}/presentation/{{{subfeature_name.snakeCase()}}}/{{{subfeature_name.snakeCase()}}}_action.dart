// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for {{subfeature_name.pascalCase()}} subfeature (INPUT: View → ViewModel)
sealed class {{subfeature_name.pascalCase()}}Action extends BaseAction {
  const {{subfeature_name.pascalCase()}}Action();
}

/// Load data
class Load{{subfeature_name.pascalCase()}}Action extends {{subfeature_name.pascalCase()}}Action {
  const Load{{subfeature_name.pascalCase()}}Action();
}
