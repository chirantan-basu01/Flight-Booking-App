import 'package:flutter/material.dart';

/// Responsive breakpoints utility class
class Responsive {
  Responsive._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Get responsive horizontal padding
  static double horizontalPadding(BuildContext context) {
    return value(
      context,
      mobile: 20.0,
      tablet: 40.0,
      desktop: 80.0,
    );
  }

  /// Get responsive card width for flight cards
  static double? flightCardWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 400;
    } else if (isTablet(context)) {
      return (MediaQuery.of(context).size.width - 60) / 2; // 2 columns
    }
    return null; // Full width on mobile
  }

  /// Get number of columns for grid layouts
  static int gridColumns(BuildContext context) {
    return value(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  /// Get responsive font scale
  static double fontScale(BuildContext context) {
    return value(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.15,
    );
  }

  /// Get max content width for centered layouts
  static double maxContentWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 720.0,
      desktop: 1200.0,
    );
  }
}

/// Extension for responsive values
extension ResponsiveExtension on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);

  double get horizontalPadding => Responsive.horizontalPadding(this);
  double get maxContentWidth => Responsive.maxContentWidth(this);
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Responsive.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// Wrapper to center content with max width
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Responsive.maxContentWidth(context),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
          ),
          child: child,
        ),
      ),
    );
  }
}