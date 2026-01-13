// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Actions for Trends feature (INPUT: View → ViewModel)
/// Represents user interactions and system triggers
sealed class TrendsAction extends BaseAction {
  const TrendsAction();
}

/// Load all trendss
class LoadAllTrendssAction extends TrendsAction {
  const LoadAllTrendssAction();
}

/// Load single trends
class LoadTrendsAction extends TrendsAction {
  final String id;

  const LoadTrendsAction(this.id);
}

/// Create trends
class CreateTrendsAction extends TrendsAction {
  final String name;
  // TODO: Add parameters

  const CreateTrendsAction({required this.name});
}

/// Update trends
class UpdateTrendsAction extends TrendsAction {
  final String id;
  final String name;
  // TODO: Add parameters

  const UpdateTrendsAction({required this.id, required this.name});
}

/// Delete trends
class DeleteTrendsAction extends TrendsAction {
  final String id;

  const DeleteTrendsAction(this.id);
}

/// Refresh trendss
class RefreshTrendssAction extends TrendsAction {
  const RefreshTrendssAction();
}
