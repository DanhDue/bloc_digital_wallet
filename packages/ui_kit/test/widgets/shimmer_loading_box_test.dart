// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_kit/widgets/shimmer_loading_box.dart';

void main() {
  group('ShimmerLoadingBox Widget Tests', () {
    testWidgets('renders with specified dimensions and default styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoadingBox(
              width: 120,
              height: 40,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      );

      final shimmerFinder = find.byType(Shimmer);
      expect(shimmerFinder, findsOneWidget);

      final boxFinder = find.byType(ShimmerLoadingBox);
      expect(boxFinder, findsOneWidget);

      final sizedBoxFinder = find.descendant(of: boxFinder, matching: find.byType(SizedBox));
      expect(sizedBoxFinder, findsWidgets);

      final SizedBox sizedBox = tester.widget<SizedBox>(sizedBoxFinder.first);
      expect(sizedBox.width, 120);
      expect(sizedBox.height, 40);
    });

    testWidgets('supports custom colors and circular radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoadingBox(
              width: 60,
              height: 60,
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
        ),
      );

      final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
      expect(shimmer, isNotNull);
    });
  });
}
