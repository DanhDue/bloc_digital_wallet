// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Home feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class HomeAction extends BaseAction {
  const HomeAction();
}

/// Load all homes
class LoadAllHomesAction extends HomeAction {
  const LoadAllHomesAction();
}

/// Load single home
class LoadHomeAction extends HomeAction {
  final String id;

  const LoadHomeAction(this.id);
}

/// Create home
class CreateHomeAction extends HomeAction {
  final String name;
  // TODO: Add parameters

  const CreateHomeAction({required this.name});
}

/// Update home
class UpdateHomeAction extends HomeAction {
  final String id;
  final String name;
  // TODO: Add parameters

  const UpdateHomeAction({required this.id, required this.name});
}

/// Delete home
class DeleteHomeAction extends HomeAction {
  final String id;

  const DeleteHomeAction(this.id);
}

/// Refresh homes
class RefreshHomesAction extends HomeAction {
  const RefreshHomesAction();
}
