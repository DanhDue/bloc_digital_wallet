// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/widgets/shimmer_loading_box.dart';

/// An optimized cached network image wrapper that computes physical pixel decode boundaries
/// based on logical dimensions and device pixel ratio (DPR) to reduce RAM usage by >95%.
class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool enableShimmer;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.enableShimmer = true,
    this.placeholder,
    this.errorWidget,
  });

  /// Computes the physical pixel decode boundary [memCacheWidth] / [memCacheHeight]
  /// based on the given logical dimension and [devicePixelRatio].
  ///
  /// Returns `null` if [logicalSize] is null or non-positive.
  /// If [devicePixelRatio] is non-positive, it defaults safely to 1.0.
  static int? computeMemCacheDimension(double? logicalSize, double devicePixelRatio) {
    if (logicalSize == null || logicalSize <= 0) {
      return null;
    }
    final dpr = devicePixelRatio > 0 ? devicePixelRatio : 1.0;
    return (logicalSize * dpr).round();
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl);
    final isValidUrl = imageUrl.isNotEmpty && uri != null && uri.hasScheme;

    if (!isValidUrl) {
      return _buildErrorWidget(context, imageUrl, Exception('Invalid image URL: "$imageUrl"'));
    }

    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 1.0;
    final memWidth = computeMemCacheDimension(width, dpr);
    final memHeight = computeMemCacheDimension(height, dpr);

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memWidth,
      memCacheHeight: memHeight,
      placeholder: placeholder ?? (enableShimmer ? _defaultShimmerPlaceholder : null),
      errorWidget: errorWidget ?? _buildErrorWidget,
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _defaultShimmerPlaceholder(BuildContext context, String url) {
    return ShimmerLoadingBox(width: width, height: height, borderRadius: borderRadius);
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          size: (width != null && height != null)
              ? (width! < height! ? width! * 0.5 : height! * 0.5)
              : 24,
        ),
      ),
    );
  }
}
