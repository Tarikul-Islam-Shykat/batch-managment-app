import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageShape { rectangle, roundedRectangle, circle }

enum ImageSourceType { network, asset, file }

class ResponsiveImage extends StatelessWidget {
  const ResponsiveImage({
    super.key,
    required this.imageSource,
    required this.sourceType,
    this.shape = ImageShape.roundedRectangle,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  const ResponsiveImage.network({
    super.key,
    required String url,
    this.shape = ImageShape.roundedRectangle,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : imageSource = url,
       sourceType = ImageSourceType.network;

  const ResponsiveImage.asset({
    super.key,
    required String assetPath,
    this.shape = ImageShape.roundedRectangle,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : imageSource = assetPath,
       sourceType = ImageSourceType.asset;

  const ResponsiveImage.file({
    super.key,
    required String filePath,
    this.shape = ImageShape.roundedRectangle,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : imageSource = filePath,
       sourceType = ImageSourceType.file;

  final String imageSource;
  final ImageSourceType sourceType;
  final ImageShape shape;
  final double borderRadius;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  Widget _fallback(double? w, double? h) {
    return errorWidget ??
        Container(
          width: w,
          height: h,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
        );
  }

  Widget _buildImage(double? w, double? h) {
    switch (sourceType) {
      case ImageSourceType.network:
        return CachedNetworkImage(
          imageUrl: imageSource,
          width: w,
          height: h,
          fit: fit,
          placeholder: placeholder != null
              ? (context, url) => placeholder!
              : (context, url) => Container(
                  width: w,
                  height: h,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
          errorWidget: (context, url, error) => _fallback(w, h),
        );
      case ImageSourceType.asset:
        return Image.asset(
          imageSource,
          width: w,
          height: h,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _fallback(w, h),
        );
      case ImageSourceType.file:
        return Image.file(
          File(imageSource),
          width: w,
          height: h,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _fallback(w, h),
        );
    }
  }

  Widget _applyShape(Widget child) {
    switch (shape) {
      case ImageShape.rectangle:
        return ClipRect(child: child);
      case ImageShape.roundedRectangle:
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        );
      case ImageShape.circle:
        return ClipOval(child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildImage(width, height);
    return _applyShape(child);
  }
}
