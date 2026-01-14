// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// {{subfeature_name.pascalCase()}} Actions
/// ============================================================================
/// Actions represent user intents or system events.
/// 
/// HOW TO EXTEND:
/// 1. Add new action classes for different user intents
/// 2. Each action should extend {{subfeature_name.pascalCase()}}Action
/// 3. Include any data needed to process the action
/// ============================================================================

sealed class {{subfeature_name.pascalCase()}}Action extends BaseAction {
  const {{subfeature_name.pascalCase()}}Action();
}

/// Action to load/initialize the feature
class Load{{subfeature_name.pascalCase()}}Action extends {{subfeature_name.pascalCase()}}Action {
  const Load{{subfeature_name.pascalCase()}}Action();
}
