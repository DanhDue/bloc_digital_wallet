// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Sample feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class SampleAction extends BaseAction {
  const SampleAction();
}

/// Load all items
class LoadAllSamplesAction extends SampleAction {
  const LoadAllSamplesAction();
}

/// Load single item by id
class LoadSampleAction extends SampleAction {
  final String id;
  const LoadSampleAction(this.id);
}

/// Create new item
class CreateSampleAction extends SampleAction {
  final String name;
  const CreateSampleAction({required this.name});
}

/// Update existing item
class UpdateSampleAction extends SampleAction {
  final String id;
  final String name;
  const UpdateSampleAction({required this.id, required this.name});
}

/// Delete item
class DeleteSampleAction extends SampleAction {
  final String id;
  const DeleteSampleAction(this.id);
}

/// Refresh items
class RefreshSamplesAction extends SampleAction {
  const RefreshSamplesAction();
}
