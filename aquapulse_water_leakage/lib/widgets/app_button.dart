import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outlined, danger }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide? borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = AppColors.primaryTeal;
        fgColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        bgColor = AppColors.turquoise;
        fgColor = Colors.white;
        break;
      case AppButtonVariant.outlined:
        bgColor = Colors.transparent;
        fgColor = AppColors.primaryTeal;
        borderSide = const BorderSide(color: AppColors.primaryTeal, width: 1.5);
        break;
      case AppButtonVariant.danger:
        bgColor = AppColors.redCritical;
        fgColor = Colors.white;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: variant == AppButtonVariant.outlined ? 0 : 2,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: fgColor),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: fgColor,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
