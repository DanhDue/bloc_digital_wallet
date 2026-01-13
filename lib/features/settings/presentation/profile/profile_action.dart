// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Profile subfeature (INPUT: View → ViewModel)
sealed class ProfileAction extends BaseAction {
  const ProfileAction();
}

/// Load data
class LoadProfileAction extends ProfileAction {
  const LoadProfileAction();
}
