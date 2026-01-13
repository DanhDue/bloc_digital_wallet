// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for {{feature_name.pascalCase()}} feature (INPUT: View → ViewModel)
sealed class {{feature_name.pascalCase()}}Action extends BaseAction {
  const {{feature_name.pascalCase()}}Action();
}

/// Load data
class Load{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
  const Load{{feature_name.pascalCase()}}Action();
}
