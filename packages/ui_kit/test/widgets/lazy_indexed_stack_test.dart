// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

class _StatefulTestChild extends StatefulWidget {
  final String label;
  const _StatefulTestChild({required this.label});

  @override
  State<_StatefulTestChild> createState() => _StatefulTestChildState();
}

class _StatefulTestChildState extends State<_StatefulTestChild> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.label),
        Text('Count: $counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: Text('Increment ${widget.label}'),
        ),
      ],
    );
  }
}

void main() {
  group('LazyIndexedStack Unit & Widget Tests', () {
    testWidgets('mounts only the initial active child on Frame 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LazyIndexedStack(
              index: 2,
              children: [
                _StatefulTestChild(label: 'Child 0'),
                _StatefulTestChild(label: 'Child 1'),
                _StatefulTestChild(label: 'Child 2'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Child 2'), findsOneWidget);
      expect(find.text('Child 0'), findsNothing);
      expect(find.text('Child 1'), findsNothing);
    });

    testWidgets('switching to unmounted tab instantiates it and preserves state of previous tab', (
      tester,
    ) async {
      int activeIndex = 2;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: LazyIndexedStack(
                  index: activeIndex,
                  children: const [
                    _StatefulTestChild(label: 'Child 0'),
                    _StatefulTestChild(label: 'Child 1'),
                    _StatefulTestChild(label: 'Child 2'),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => setState(() => activeIndex = 0),
                ),
              ),
            );
          },
        ),
      );

      // Verify Child 2 is mounted
      expect(find.text('Child 2'), findsOneWidget);
      expect(find.text('Count: 0'), findsOneWidget);

      // Increment count on Child 2
      await tester.tap(find.text('Increment Child 2'));
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);

      // Switch to Child 0
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Child 0 is now mounted and onscreen
      expect(find.text('Child 0'), findsOneWidget);
      // Child 1 is still unmounted completely (neither onscreen nor offstage)
      expect(find.text('Child 1', skipOffstage: false), findsNothing);
      // Child 2 is still preserved in tree offstage with its counter = 1
      expect(find.text('Count: 1', skipOffstage: false), findsOneWidget);
    });

    testWidgets('clamps out of bounds index gracefully without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LazyIndexedStack(
              index: 99,
              children: [Text('First Child'), Text('Second Child')],
            ),
          ),
        ),
      );

      // Should clamp to index 1 (Second Child)
      expect(find.text('Second Child'), findsOneWidget);
      expect(find.text('First Child'), findsNothing);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LazyIndexedStack(
              index: -5,
              children: [Text('First Child'), Text('Second Child')],
            ),
          ),
        ),
      );

      // Should clamp to index 0 (First Child)
      expect(find.text('First Child'), findsOneWidget);
    });

    testWidgets('handles empty children list gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LazyIndexedStack(index: 0, children: [])),
        ),
      );

      expect(find.byType(LazyIndexedStack), findsOneWidget);
    });
  });
}
