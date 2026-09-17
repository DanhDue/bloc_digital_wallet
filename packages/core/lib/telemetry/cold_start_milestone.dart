// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Key lifecycle milestones during Flutter application cold start.
enum ColdStartMilestone {
  /// Entered void main().
  mainEntry,

  /// WidgetsFlutterBinding.ensureInitialized() has finished.
  bindingInitialized,

  /// Started dependency injection registration (configureDependencies).
  diStarted,

  /// Dependency injection graph is fully ready.
  diReady,

  /// Started core services and initializers (ThemeManager, AppInitializer).
  coreServicesStarted,

  /// Core services and initializers have resolved.
  coreServicesReady,

  /// runApp() has been invoked.
  runAppInvoked,

  /// First frame has rendered on screen (First Contentful Paint / FCP).
  firstFrameRendered,

  /// ShellPage and initial default tab are fully loaded and interactive (TTI).
  firstScreenInteractive,
}

/// A timestamped record of a specific cold-start milestone.
class MilestoneRecord {
  /// The recorded milestone.
  final ColdStartMilestone milestone;

  /// Epoch timestamp in microseconds.
  final int timestampMicros;

  /// Elapsed microseconds since profiler start.
  final int elapsedMicrosSinceStart;

  /// Optional contextual information.
  final String? extra;

  const MilestoneRecord({
    required this.milestone,
    required this.timestampMicros,
    required this.elapsedMicrosSinceStart,
    this.extra,
  });

  /// Duration elapsed since the start of cold-start profiling.
  Duration get elapsed => Duration(microseconds: elapsedMicrosSinceStart);
}
