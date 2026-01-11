// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Events for {{feature_name.pascalCase()}} feature (OUTPUT: ViewModel → View)
/// One-time side effects: Navigation, Toast, Dialog (Transient)
sealed class {{feature_name.pascalCase()}}Event extends BaseEvent {
  const {{feature_name.pascalCase()}}Event();
}

/// Show success message (Toast/Snackbar)
class ShowSuccessMessage extends {{feature_name.pascalCase()}}Event {
  final String message;
  
  const ShowSuccessMessage(this.message);
}

/// Show error message (Toast/Snackbar)
class ShowErrorMessage extends {{feature_name.pascalCase()}}Event {
  final String message;
  
  const ShowErrorMessage(this.message);
}

/// Navigate to detail page
class NavigateTo{{feature_name.pascalCase()}}Detail extends {{feature_name.pascalCase()}}Event {
  final String id;
  
  const NavigateTo{{feature_name.pascalCase()}}Detail(this.id);
}

/// Navigate back
class NavigateBack extends {{feature_name.pascalCase()}}Event {
  const NavigateBack();
}
