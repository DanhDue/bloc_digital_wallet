// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Settings feature (INPUT: View → ViewModel)
sealed class SettingsAction extends BaseAction {
  const SettingsAction();
}

/// Load data
class LoadSettingsAction extends SettingsAction {
  const LoadSettingsAction();
}

class NavigateToProfile extends SettingsAction {
  const NavigateToProfile();
}
