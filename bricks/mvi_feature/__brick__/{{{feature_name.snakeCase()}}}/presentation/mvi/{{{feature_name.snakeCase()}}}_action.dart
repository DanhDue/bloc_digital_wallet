// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for {{feature_name.pascalCase()}} feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class {{feature_name.pascalCase()}}Action extends BaseAction {
  const {{feature_name.pascalCase()}}Action();
}

/// Load all {{feature_name.lowerCase()}}s
class LoadAll{{feature_name.pascalCase()}}sAction extends {{feature_name.pascalCase()}}Action {
  const LoadAll{{feature_name.pascalCase()}}sAction();
}

/// Load single {{feature_name.lowerCase()}}
class Load{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
  final String id;
  
  const Load{{feature_name.pascalCase()}}Action(this.id);
}

/// Create {{feature_name.lowerCase()}}
class Create{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
  final String name;
  // TODO: Add parameters
  
  const Create{{feature_name.pascalCase()}}Action({required this.name});
}

/// Update {{feature_name.lowerCase()}}
class Update{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
  final String id;
  final String name;
  // TODO: Add parameters
  
  const Update{{feature_name.pascalCase()}}Action({
    required this.id,
    required this.name,
  });
}

/// Delete {{feature_name.lowerCase()}}
class Delete{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
  final String id;
  
  const Delete{{feature_name.pascalCase()}}Action(this.id);
}

/// Refresh {{feature_name.lowerCase()}}s
class Refresh{{feature_name.pascalCase()}}sAction extends {{feature_name.pascalCase()}}Action {
  const Refresh{{feature_name.pascalCase()}}sAction();
}
