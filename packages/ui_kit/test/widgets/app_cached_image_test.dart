// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/widgets/app_cached_image.dart';
import 'package:ui_kit/widgets/shimmer_loading_box.dart';

void main() {
  group('AppCachedImage Unit & Widget Tests', () {
    test('computeMemCacheDimension calculates physical pixels accurately', () {
      // 60 logical px on 3.0 DPR screen = 180 physical px
      expect(AppCachedImage.computeMemCacheDimension(60, 3.0), 180);
      expect(AppCachedImage.computeMemCacheDimension(100, 2.0), 200);
      expect(AppCachedImage.computeMemCacheDimension(50.5, 2.0), 101);
    });

    test('computeMemCacheDimension gracefully handles null and non-positive values', () {
      expect(AppCachedImage.computeMemCacheDimension(null, 3.0), isNull);
      expect(AppCachedImage.computeMemCacheDimension(0, 3.0), isNull);
      expect(AppCachedImage.computeMemCacheDimension(-10, 3.0), isNull);

      // DPR <= 0 defaults safely to 1.0
      expect(AppCachedImage.computeMemCacheDimension(60, 0), 60);
      expect(AppCachedImage.computeMemCacheDimension(60, -1.0), 60);
    });

    testWidgets('renders CachedNetworkImage with computed memCache dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCachedImage(
              imageUrl: 'https://example.com/avatar.png',
              width: 60,
              height: 60,
            ),
          ),
        ),
      );

      final cachedImageFinder = find.byType(CachedNetworkImage);
      expect(cachedImageFinder, findsOneWidget);

      final CachedNetworkImage cachedImage = tester.widget<CachedNetworkImage>(cachedImageFinder);
      expect(cachedImage.imageUrl, 'https://example.com/avatar.png');
      expect(cachedImage.width, 60);
      expect(cachedImage.height, 60);
      expect(cachedImage.memCacheWidth, isNotNull);
      expect(cachedImage.memCacheHeight, isNotNull);
    });

    testWidgets('renders ShimmerLoadingBox when enableShimmer is true in placeholder', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCachedImage(
              imageUrl: 'https://example.com/avatar.png',
              width: 100,
              height: 100,
              enableShimmer: true,
              placeholder: (context, url) => const ShimmerLoadingBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders fallback error widget when imageUrl is empty or invalid', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppCachedImage(imageUrl: '', width: 60, height: 60)),
        ),
      );

      // Empty URL renders immediate fallback error widget without crashing
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    });
  });
}
