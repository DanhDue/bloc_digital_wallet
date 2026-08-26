// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';

void main() {
  final timestamp = DateTime.utc(2026, 1, 1, 12);

  LogRecord record({
    required String spanId,
    String? parentSpanId,
    String traceId = 'trace-1',
    String message = 'event',
  }) => LogRecord(
    module: 'wallet',
    level: LogLevel.info,
    message: message,
    timestamp: timestamp,
    traceId: traceId,
    spanId: spanId,
    parentSpanId: parentSpanId,
  );

  group('buildTraceTree', () {
    test('empty list yields an empty tree', () {
      expect(buildTraceTree(const []), isEmpty);
    });

    test('flat list with no parent produces one root per record', () {
      final records = [
        record(spanId: 'a'),
        record(spanId: 'b'),
        record(spanId: 'c'),
      ];

      final tree = buildTraceTree(records);

      expect(tree, hasLength(3));
      expect(tree.map((n) => n.record.spanId), ['a', 'b', 'c']);
      for (final node in tree) {
        expect(node.children, isEmpty);
      }
    });

    test('single-parent chain nests each record under its parent', () {
      final root = record(spanId: 'a');
      final child = record(spanId: 'b', parentSpanId: 'a');
      final grandchild = record(spanId: 'c', parentSpanId: 'b');

      final tree = buildTraceTree([root, child, grandchild]);

      expect(tree, hasLength(1));
      final rootNode = tree.single;
      expect(rootNode.record.spanId, 'a');
      expect(rootNode.children, hasLength(1));

      final childNode = rootNode.children.single;
      expect(childNode.record.spanId, 'b');
      expect(childNode.children, hasLength(1));

      final grandchildNode = childNode.children.single;
      expect(grandchildNode.record.spanId, 'c');
      expect(grandchildNode.children, isEmpty);
    });

    test('multiple branches from one parent are all attached', () {
      final root = record(spanId: 'a');
      final branch1 = record(spanId: 'b', parentSpanId: 'a');
      final branch2 = record(spanId: 'c', parentSpanId: 'a');

      final tree = buildTraceTree([root, branch1, branch2]);

      expect(tree, hasLength(1));
      final rootNode = tree.single;
      expect(rootNode.children, hasLength(2));
      expect(rootNode.children.map((n) => n.record.spanId).toSet(), {'b', 'c'});
    });

    test('a record with an unknown parentSpanId is treated as a root and does '
        'not crash', () {
      final orphan = record(spanId: 'x', parentSpanId: 'does-not-exist');
      final normalRoot = record(spanId: 'a');

      expect(() => buildTraceTree([orphan, normalRoot]), returnsNormally);

      final tree = buildTraceTree([orphan, normalRoot]);
      expect(tree, hasLength(2));
      expect(tree.map((n) => n.record.spanId).toSet(), {'x', 'a'});
    });

    test('mixed chain, branch, and orphan records reconstruct correctly', () {
      final root = record(spanId: 'a');
      final child = record(spanId: 'b', parentSpanId: 'a');
      final sibling = record(spanId: 'c', parentSpanId: 'a');
      final grandchild = record(spanId: 'd', parentSpanId: 'b');
      final orphan = record(spanId: 'z', parentSpanId: 'missing');

      final tree = buildTraceTree([root, child, sibling, grandchild, orphan]);

      // Two roots: 'a' (real root) and 'z' (orphan, unknown parent).
      expect(tree, hasLength(2));

      final rootNode = tree.firstWhere((n) => n.record.spanId == 'a');
      expect(rootNode.children, hasLength(2));

      final childNode = rootNode.children.firstWhere(
        (n) => n.record.spanId == 'b',
      );
      expect(childNode.children.single.record.spanId, 'd');

      final orphanNode = tree.firstWhere((n) => n.record.spanId == 'z');
      expect(orphanNode.children, isEmpty);
    });

    test('records that share a spanId are never dropped — each still '
        'produces its own node', () {
      // Two top-level records from the same cached LoggerImpl carry the
      // same (fixed) spanId — a real occurrence, not just a hypothetical
      // malformed input. Neither may be silently lost.
      final first = record(spanId: 'shared', message: 'first');
      final second = record(spanId: 'shared', message: 'second');
      final child = record(
        spanId: 'child',
        parentSpanId: 'shared',
        message: 'child',
      );

      final tree = buildTraceTree([first, second, child]);

      expect(countNodes(tree), 3);

      final messages = allRecords(tree).map((r) => r.message).toSet();
      expect(messages, {'first', 'second', 'child'});
    });
  });
}

/// Total node count across an entire trace forest, including all nested
/// children, used to assert that no input record was silently dropped.
int countNodes(List<TraceNode> forest) {
  var count = 0;
  for (final node in forest) {
    count += 1;
    count += countNodes(node.children);
  }
  return count;
}

/// Every [LogRecord] in an entire trace forest, including all nested
/// children.
Iterable<LogRecord> allRecords(List<TraceNode> forest) sync* {
  for (final node in forest) {
    yield node.record;
    yield* allRecords(node.children);
  }
}
