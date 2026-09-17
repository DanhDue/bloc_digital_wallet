// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:developer' as developer;

import 'cold_start_milestone.dart';
import 'cold_start_report.dart';

/// Central profiler service capturing startup timestamps and milestone telemetry.
class ColdStartProfiler {
  static final ColdStartProfiler instance = ColdStartProfiler._();

  ColdStartProfiler._();

  /// Whether telemetry tracking is enabled. Can be disabled in Release or via configuration.
  bool enabled = true;

  Stopwatch? _stopwatch;
  int _startTimestampMicros = 0;
  final List<MilestoneRecord> _records = [];
  final Map<String, Duration> _subInitializers = {};
  developer.TimelineTask? _timelineTask;
  bool _isFinished = false;

  /// Starts the cold-start profiling stopwatch and records the [ColdStartMilestone.mainEntry].
  void start() {
    _isFinished = false;
    _records.clear();
    _subInitializers.clear();
    if (!enabled) return;

    _stopwatch = Stopwatch()..start();
    _startTimestampMicros = DateTime.now().microsecondsSinceEpoch;
    _timelineTask = developer.TimelineTask()..start('ColdStart');
    mark(ColdStartMilestone.mainEntry);
  }

  /// Records a lifecycle milestone with its elapsed duration.
  void mark(ColdStartMilestone milestone, [String? extra]) {
    if (!enabled || _stopwatch == null) return;

    final elapsedMicros = _stopwatch!.elapsedMicroseconds;
    final timestampMicros = _startTimestampMicros + elapsedMicros;

    _records.add(
      MilestoneRecord(
        milestone: milestone,
        timestampMicros: timestampMicros,
        elapsedMicrosSinceStart: elapsedMicros,
        extra: extra,
      ),
    );

    _timelineTask?.instant(milestone.name, arguments: extra != null ? {'extra': extra} : null);
  }

  /// Wraps a synchronous execution block, recording its duration and Timeline slice.
  T timeSync<T>(String name, T Function() block) {
    if (!enabled) return block();

    developer.Timeline.startSync('ColdStart: $name');
    final sw = Stopwatch()..start();
    try {
      return block();
    } finally {
      sw.stop();
      developer.Timeline.finishSync();
      _subInitializers[name] = sw.elapsed;
    }
  }

  /// Wraps an asynchronous execution block, recording its duration and Timeline slice.
  Future<T> timeAsync<T>(String name, Future<T> Function() block) async {
    if (!enabled) return await block();

    final task = developer.TimelineTask(parent: _timelineTask)..start('ColdStart: $name');
    final sw = Stopwatch()..start();
    try {
      return await block();
    } finally {
      sw.stop();
      task.finish();
      _subInitializers[name] = sw.elapsed;
    }
  }

  /// Marks the completion of the cold-start sequence. Idempotent.
  void finish() {
    if (!enabled || _isFinished || _stopwatch == null) return;
    _isFinished = true;
    _stopwatch!.stop();
    _timelineTask?.finish();
  }

  /// Resets internal buffers for testing or next runs.
  void reset() {
    _isFinished = false;
    _records.clear();
    _subInitializers.clear();
    _stopwatch = null;
    _timelineTask = null;
    _startTimestampMicros = 0;
  }

  /// Returns an immutable snapshot of the cold-start report.
  ColdStartReport get report => ColdStartReport(
    records: List.unmodifiable(_records),
    subInitializersDuration: Map.unmodifiable(_subInitializers),
    startTimestampMicros: _startTimestampMicros,
    endTimestampMicros: _stopwatch != null
        ? _startTimestampMicros + _stopwatch!.elapsedMicroseconds
        : null,
  );

  /// Formats and delivers the report to the provided [logger] callback.
  void logReport(void Function(String) logger) {
    if (!enabled) return;
    logger(report.toFormattedAsciiTable());
  }
}
