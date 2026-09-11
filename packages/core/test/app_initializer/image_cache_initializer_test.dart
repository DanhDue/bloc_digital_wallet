// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/app_initializer/image_cache_initializer.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageCacheInitializer', () {
    test('configures global ImageCache limits with default values (50MB / 100 items)', () async {
      const initializer = ImageCacheInitializer();

      await initializer.init();

      expect(PaintingBinding.instance.imageCache.maximumSize, 100);
      expect(PaintingBinding.instance.imageCache.maximumSizeBytes, 50 * 1024 * 1024);
    });

    test('supports custom maximumSize and maximumSizeBytes', () async {
      const initializer = ImageCacheInitializer(
        maximumSize: 200,
        maximumSizeBytes: 100 * 1024 * 1024,
      );

      await initializer.init();

      expect(PaintingBinding.instance.imageCache.maximumSize, 200);
      expect(PaintingBinding.instance.imageCache.maximumSizeBytes, 100 * 1024 * 1024);
    });
  });
}
