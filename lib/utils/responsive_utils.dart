import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveUtils {
  /// Check if device is tablet based on shortest side
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  /// Get device scale factor for intelligent scaling
  static double _getScaleFactor(BuildContext context) {
    if (!isTablet(context)) return 1.0;

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    // For tablets (600-800): scale to 1.2-1.4x of phone size
    // For large tablets (800+): scale to 1.4-1.6x of phone size
    if (shortestSide >= 800) {
      return 1.5; // Large tablet - moderate increase
    } else {
      return 1.3; // Standard tablet - small increase
    }
  }

  /// Get responsive font size with smart scaling
  /// Small fonts increase more, large fonts increase less
  static double sp(double size, BuildContext context) {
    if (!isTablet(context)) {
      return size.sp;
    }

    final scaleFactor = _getScaleFactor(context);
    double adjustedSize;

    // Smart scaling: smaller text grows more, larger text grows less
    if (size <= 12) {
      adjustedSize = size * (scaleFactor * 1.1); // Small text: +10%
    } else if (size <= 16) {
      adjustedSize = size * scaleFactor; // Medium text: normal
    } else if (size <= 24) {
      adjustedSize = size * (scaleFactor * 0.9); // Large text: -10%
    } else {
      adjustedSize = size * (scaleFactor * 0.8); // Very large text: -20%
    }

    return adjustedSize;
  }

  /// Get responsive width with smart scaling
  static double w(double width, BuildContext context) {
    if (!isTablet(context)) {
      return width.w;
    }

    // On tablets, use actual pixel values instead of scaled values
    // This prevents UI elements from being too large
    return width * 1.2; // Slight increase for better touch targets
  }

  /// Get responsive height with smart scaling
  static double h(double height, BuildContext context) {
    if (!isTablet(context)) {
      return height.h;
    }

    // On tablets, use actual pixel values with moderate scaling
    return height * 1.2; // Slight increase
  }

  /// Get responsive radius with smart scaling
  static double r(double radius, BuildContext context) {
    if (!isTablet(context)) {
      return radius.r;
    }

    // Tablets: slightly larger radius for better aesthetics
    return radius * 1.3;
  }

  /// Get responsive padding/margin with smart scaling
  static EdgeInsets padding({
    required BuildContext context,
    double all = 0,
    double horizontal = 0,
    double vertical = 0,
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) {
    final factor = isTablet(context) ? 1.4 : 1.0;

    if (all > 0) {
      return EdgeInsets.all(all * factor);
    }

    if (horizontal > 0 || vertical > 0) {
      return EdgeInsets.symmetric(
        horizontal: horizontal * factor,
        vertical: vertical * factor,
      );
    }

    return EdgeInsets.only(
      top: top * factor,
      bottom: bottom * factor,
      left: left * factor,
      right: right * factor,
    );
  }

  /// Get icon size with smart scaling
  static double iconSize(double size, BuildContext context) {
    if (!isTablet(context)) {
      return size;
    }

    // Icons on tablets: moderate increase for better visibility
    return size * 1.4;
  }

  /// Get responsive sized box
  static SizedBox sizedBoxH(double height, BuildContext context) {
    return SizedBox(height: h(height, context));
  }

  static SizedBox sizedBoxW(double width, BuildContext context) {
    return SizedBox(width: w(width, context));
  }

  /// Get max content width for tablets (prevents content from stretching too wide)
  static double getMaxContentWidth(BuildContext context) {
    if (!isTablet(context)) {
      return double.infinity;
    }
    return 900; // Max width for tablet content to prevent stretching
  }

  /// Get grid columns count based on device
  static int getGridColumns(BuildContext context) {
    if (isTablet(context)) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth >= 1024) return 4; // Large tablet landscape
      if (screenWidth >= 800) return 3; // Tablet landscape
      return 2; // Tablet portrait
    }
    return 2; // Phone
  }

  /// Get button height for better touch targets on tablets
  static double getButtonHeight(BuildContext context) {
    return isTablet(context) ? 60.0 : 48.0;
  }

  /// Get card elevation
  static double getCardElevation(BuildContext context) {
    return isTablet(context) ? 6.0 : 2.0;
  }
}
