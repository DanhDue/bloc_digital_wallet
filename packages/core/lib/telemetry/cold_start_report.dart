// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'cold_start_milestone.dart';

/// Immutable summary of the application cold-start performance metrics.
class ColdStartReport {
  /// All milestone records captured in chronological order.
  final List<MilestoneRecord> records;

  /// Individual durations recorded for sub-initializers.
  final Map<String, Duration> subInitializersDuration;

  /// Timestamp in microseconds when profiling started.
  final int startTimestampMicros;

  /// Optional timestamp in microseconds when profiling finished.
  final int? endTimestampMicros;

  const ColdStartReport({
    required this.records,
    required this.subInitializersDuration,
    required this.startTimestampMicros,
    this.endTimestampMicros,
  });

  /// Finds the elapsed duration for a specific milestone.
  Duration? elapsedFor(ColdStartMilestone milestone) {
    for (final r in records) {
      if (r.milestone == milestone) {
        return r.elapsed;
      }
    }
    return null;
  }

  /// Total duration from main() entry to First Contentful Paint (first frame rendered).
  Duration get totalToFcp => elapsedFor(ColdStartMilestone.firstFrameRendered) ?? Duration.zero;

  /// Total duration from main() entry to Time To Interactive (ShellPage & first screen interactive).
  Duration get totalToTti =>
      elapsedFor(ColdStartMilestone.firstScreenInteractive) ??
      (endTimestampMicros != null
          ? Duration(microseconds: endTimestampMicros! - startTimestampMicros)
          : totalToFcp);

  /// Duration spent initializing Flutter framework bindings.
  Duration get bindingDuration {
    final start = elapsedFor(ColdStartMilestone.mainEntry) ?? Duration.zero;
    final end = elapsedFor(ColdStartMilestone.bindingInitialized) ?? start;
    return end - start;
  }

  /// Duration spent configuring dependency injection graph.
  Duration get diDuration {
    final start = elapsedFor(ColdStartMilestone.diStarted) ?? Duration.zero;
    final end = elapsedFor(ColdStartMilestone.diReady) ?? start;
    return end - start;
  }

  /// Duration spent initializing core services (ThemeManager, AppInitializer).
  Duration get coreServicesDuration {
    final start = elapsedFor(ColdStartMilestone.coreServicesStarted) ?? Duration.zero;
    final end = elapsedFor(ColdStartMilestone.coreServicesReady) ?? start;
    return end - start;
  }

  /// Formats the report into a structured, human-readable ASCII table.
  String toFormattedAsciiTable() {
    final totalMs = totalToTti.inMicroseconds / 1000.0;
    final totalFcpMs = totalToFcp.inMicroseconds / 1000.0;

    String pct(Duration d) {
      if (totalMs <= 0) return '  0.0%';
      final p = ((d.inMicroseconds / 1000.0) / totalMs) * 100.0;
      return '${p.toStringAsFixed(1).padLeft(5)}%';
    }

    String ms(Duration d) {
      final val = (d.inMicroseconds / 1000.0).toStringAsFixed(1);
      return '${val.padLeft(6)} ms';
    }

    final buffer = StringBuffer();
    buffer.writeln('┌──────────────────────────────────────────────────────────────┐');
    buffer.writeln('│ 🚀 COLD START PERFORMANCE TELEMETRY REPORT                   │');
    buffer.writeln('├──────────────────────────────────────┬─────────────┬─────────┤');
    buffer.writeln('│ Milestone / Phase                    │ Time (ms)   │ % Total │');
    buffer.writeln('├──────────────────────────────────────┼─────────────┼─────────┤');

    buffer.writeln(
      '│ 1. Engine & Binding Init             │ ${ms(bindingDuration)} │ ${pct(bindingDuration)} │',
    );
    buffer.writeln(
      '│ 2. Dependency Injection (GetIt)      │ ${ms(diDuration)} │ ${pct(diDuration)} │',
    );
    buffer.writeln(
      '│ 3. Core Services & Initializers      │ ${ms(coreServicesDuration)} │ ${pct(coreServicesDuration)} │',
    );

    if (subInitializersDuration.isNotEmpty) {
      final entries = subInitializersDuration.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final isLast = i == entries.length - 1;
        final prefix = isLast ? '   └─ ' : '   ├─ ';
        final rawName = entries[i].key;
        final truncatedName = rawName.length > 25 ? '${rawName.substring(0, 22)}...' : rawName;
        final paddedName = (prefix + truncatedName).padRight(36);
        buffer.writeln('│ $paddedName │ ${ms(entries[i].value)} │ ${pct(entries[i].value)} │');
      }
    }

    final runAppStart = elapsedFor(ColdStartMilestone.runAppInvoked) ?? Duration.zero;
    final fcp = elapsedFor(ColdStartMilestone.firstFrameRendered) ?? runAppStart;
    final widgetTreeDuration = fcp > runAppStart ? fcp - runAppStart : Duration.zero;
    buffer.writeln(
      '│ 4. Widget Tree Build (runApp)        │ ${ms(widgetTreeDuration)} │ ${pct(widgetTreeDuration)} │',
    );

    final tti = elapsedFor(ColdStartMilestone.firstScreenInteractive) ?? fcp;
    final shellInteractiveDuration = tti > fcp ? tti - fcp : Duration.zero;
    buffer.writeln(
      '│ 5. First Contentful Paint (FCP)      │ ${ms(totalToFcp)} │ ${pct(totalToFcp)} │',
    );
    buffer.writeln(
      '│ 6. Shell & First Screen Interactive  │ ${ms(shellInteractiveDuration)} │ ${pct(shellInteractiveDuration)} │',
    );

    buffer.writeln('├──────────────────────────────────────┼─────────────┼─────────┤');
    buffer.writeln(
      '│ 🏁 TOTAL COLD START TIME (to FCP)    │ ${totalFcpMs.toStringAsFixed(1).padLeft(6)} ms │         │',
    );
    buffer.writeln(
      '│ 🎯 TIME TO INTERACTIVE (TTI)         │ ${totalMs.toStringAsFixed(1).padLeft(6)} ms │  100.0% │',
    );
    buffer.writeln('└──────────────────────────────────────┴─────────────┴─────────┘');

    return buffer.toString();
  }
}
