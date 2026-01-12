// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Intents for {{feature_name.pascalCase()}} feature
sealed class {{feature_name.pascalCase()}}Intent extends BaseIntent {
  const {{feature_name.pascalCase()}}Intent();
}

/// Load all {{feature_name.lowerCase()}}s
class LoadAll{{feature_name.pascalCase()}}sIntent extends {{feature_name.pascalCase()}}Intent {
  const LoadAll{{feature_name.pascalCase()}}sIntent();
}

/// Load single {{feature_name.lowerCase()}}
class Load{{feature_name.pascalCase()}}Intent extends {{feature_name.pascalCase()}}Intent {
  final String id;
  
  const Load{{feature_name.pascalCase()}}Intent(this.id);
}

/// Create {{feature_name.lowerCase()}}
class Create{{feature_name.pascalCase()}}Intent extends {{feature_name.pascalCase()}}Intent {
  final String name;
  // TODO: Add parameters
  
  const Create{{feature_name.pascalCase()}}Intent({required this.name});
}

/// Update {{feature_name.lowerCase()}}
class Update{{feature_name.pascalCase()}}Intent extends {{feature_name.pascalCase()}}Intent {
  final String id;
  final String name;
  // TODO: Add parameters
  
  const Update{{feature_name.pascalCase()}}Intent({
    required this.id,
    required this.name,
  });
}

/// Delete {{feature_name.lowerCase()}}
class Delete{{feature_name.pascalCase()}}Intent extends {{feature_name.pascalCase()}}Intent {
  final String id;
  
  const Delete{{feature_name.pascalCase()}}Intent(this.id);
}

/// Refresh {{feature_name.lowerCase()}}s
class Refresh{{feature_name.pascalCase()}}sIntent extends {{feature_name.pascalCase()}}Intent {
  const Refresh{{feature_name.pascalCase()}}sIntent();
}
