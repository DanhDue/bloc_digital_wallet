// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Actions
/// ============================================================================
/// Actions represent user intentions/interactions from the UI.
/// 
/// HOW TO EXTEND:
/// 1. Create action classes for each user interaction
/// 2. Each action should extend {{feature_name.pascalCase()}}Action
/// 3. Include any data needed to process the action
/// 
/// EXAMPLE - Adding actions:
/// ```dart
/// class Load{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
///   const Load{{feature_name.pascalCase()}}Action();
/// }
/// 
/// class Submit{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
///   final String data;
///   const Submit{{feature_name.pascalCase()}}Action(this.data);
/// }
/// 
/// class Refresh{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
///   const Refresh{{feature_name.pascalCase()}}Action();
/// }
/// ```
/// ============================================================================

sealed class {{feature_name.pascalCase()}}Action extends BaseAction {
  const {{feature_name.pascalCase()}}Action();
}

/// Initialize action - called when the feature starts
class Init{{feature_name.pascalCase()}}Action extends {{feature_name.pascalCase()}}Action {
  const Init{{feature_name.pascalCase()}}Action();
}
