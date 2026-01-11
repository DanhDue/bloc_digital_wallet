// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Side effects for {{feature_name.pascalCase()}} feature
sealed class {{feature_name.pascalCase()}}SideEffect extends BaseSideEffect {
  const {{feature_name.pascalCase()}}SideEffect();
}

/// Show success message
class ShowSuccessMessage extends {{feature_name.pascalCase()}}SideEffect {
  final String message;
  
  const ShowSuccessMessage(this.message);
}

/// Show error message
class ShowErrorMessage extends {{feature_name.pascalCase()}}SideEffect {
  final String message;
  
  const ShowErrorMessage(this.message);
}

/// Navigate to detail
class NavigateTo{{feature_name.pascalCase()}}Detail extends {{feature_name.pascalCase()}}SideEffect {
  final String id;
  
  const NavigateTo{{feature_name.pascalCase()}}Detail(this.id);
}

/// Navigate back
class NavigateBack extends {{feature_name.pascalCase()}}SideEffect {
  const NavigateBack();
}
