// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable shimmer skeleton placeholder box with configurable dimensions and styling.
class ShimmerLoadingBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoadingBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBase =
        baseColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final effectiveHighlight = highlightColor ?? theme.colorScheme.surface.withValues(alpha: 0.9);

    return Shimmer.fromColors(
      baseColor: effectiveBase,
      highlightColor: effectiveHighlight,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveBase,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
