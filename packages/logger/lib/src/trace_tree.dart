// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'log_record.dart';

/// One node in a trace tree built by [buildTraceTree]: a [LogRecord]
/// together with the records causally nested under it (i.e. records whose
/// `parentSpanId` equals this node's `record.spanId`).
class TraceNode {
  /// Creates a trace node wrapping [record] with the given [children].
  TraceNode(this.record, {List<TraceNode>? children}) : children = children ?? <TraceNode>[];

  /// The log record this node represents.
  final LogRecord record;

  /// Child nodes: records whose `parentSpanId` is this node's
  /// `record.spanId`, in the order they appeared in the input list.
  final List<TraceNode> children;
}

/// Reconstructs the causal call sequence described by [records]' `spanId`/
/// `parentSpanId` relationships into a forest of [TraceNode]s.
///
/// A record is a root of the returned forest when its `parentSpanId` is
/// `null`, **or** when it's non-null but doesn't match any `spanId` present
/// in [records] — an "orphan" reference (e.g. the parent record hasn't
/// arrived yet, or was dropped). Orphans are treated as roots rather than
/// causing an error, so a partial or out-of-order [records] list never
/// crashes this pure function.
///
/// Every record in [records] produces exactly one [TraceNode] in the
/// output, even if multiple records share the same `spanId` (e.g. several
/// top-level log calls from the same cached [LoggerImpl], which keeps its
/// `spanId` fixed for its lifetime unless [ILogger.withSpan] is used).
/// Duplicate `spanId`s are only ambiguous for *parent resolution*: the
/// first record seen with a given `spanId` is the one later records'
/// `parentSpanId` references resolve to; this never causes a record to be
/// dropped from the output.
///
/// Pure and side-effect free: reusable by any appender or UI (e.g. a
/// Talker screen grouping records by trace), not just one specific
/// consumer.
List<TraceNode> buildTraceTree(List<LogRecord> records) {
  // One node per input record, unconditionally — guarantees no record is
  // ever silently dropped, even when spanIds collide.
  final nodes = [for (final record in records) TraceNode(record)];

  // A separate spanId -> node lookup, used only to resolve parents. Built
  // with putIfAbsent so a later record with a duplicate spanId can't
  // clobber the first node registered for that spanId.
  final firstNodeBySpanId = <String, TraceNode>{};
  for (final node in nodes) {
    firstNodeBySpanId.putIfAbsent(node.record.spanId, () => node);
  }

  final roots = <TraceNode>[];

  for (final node in nodes) {
    final parentSpanId = node.record.parentSpanId;
    final parentNode = parentSpanId == null ? null : firstNodeBySpanId[parentSpanId];

    if (parentNode == null) {
      // Either a true root (no parentSpanId) or an orphan reference to a
      // parent span not present in `records` — both are treated as roots.
      roots.add(node);
    } else {
      parentNode.children.add(node);
    }
  }

  return roots;
}
