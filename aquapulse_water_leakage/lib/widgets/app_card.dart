import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Border? border;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border:
            border ??
            Border.all(
              color: AppColors.borderLight.withValues(alpha: 0.6),
              width: 1,
            ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: content,
      );
    }
    return content;
  }
}
