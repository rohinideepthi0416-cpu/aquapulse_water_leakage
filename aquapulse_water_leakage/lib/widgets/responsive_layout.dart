import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  static const double mobileMax = 650;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMax && width <= tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tabletMax;
}

/// A responsive wrapper that constrains max width on tablets and desktop
/// screens while providing full width on mobile devices.
class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = 900,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Responsive builder that selects appropriate widget based on screen width
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > ResponsiveBreakpoints.tabletMax &&
            desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= ResponsiveBreakpoints.mobileMax &&
            tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
