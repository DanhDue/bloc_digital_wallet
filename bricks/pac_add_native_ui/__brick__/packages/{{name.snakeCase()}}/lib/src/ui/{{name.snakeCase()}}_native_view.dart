// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class {{name.pascalCase()}}NativeView extends StatelessWidget {
  const {{name.pascalCase()}}NativeView({super.key});

  static const String viewType = 'com.danhdue.{{name.snakeCase()}}/native_view';

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: const <String, dynamic>{},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    } else if (Platform.isIOS) {
      return const UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    }

    return Center(
      child: Text(
        '{{name.pascalCase()}}NativeView not supported on ${Platform.operatingSystem}',
      ),
    );
  }
}
