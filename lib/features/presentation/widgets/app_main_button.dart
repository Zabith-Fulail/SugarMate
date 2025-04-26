import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_styling.dart';

class AppMainButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String title;
  final Color? color;
  final TextStyle? titleStyle;
  final bool? isEnable;
  final bool? isNegative;
  final Widget? prefixIcon;
  final double? width;
  final double? borderRadius;

  const AppMainButton({
    super.key,
    this.onTap,
    required this.title,
    this.color = AppColors.primaryColor,
    this.isEnable = true,
    this.isNegative = false,
    this.titleStyle,
    this.prefixIcon,
    this.width,
    this.borderRadius,
  });

  @override
  State<AppMainButton> createState() => _AppMainButtonState();
}

class _AppMainButtonState extends State<AppMainButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        style: widget.isNegative!
            ? ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 60,
                    ),
                  ),
                ),
                fixedSize: const WidgetStatePropertyAll(Size.infinite),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 1.7.h, horizontal: 16),
                ),
                splashFactory: InkRipple.splashFactory,
                overlayColor: WidgetStatePropertyAll(
                  AppColors.darkGrey.withValues(alpha: 0.15),
                ),
                backgroundColor: widget.isEnable!
                    ? WidgetStatePropertyAll(
                        AppColors.darkGrey.withValues(alpha: 0.3),
                      )
                    : WidgetStatePropertyAll(
                        AppColors.darkGrey.withValues(alpha: 0.3),
                      ),
                elevation: const WidgetStatePropertyAll(0),
              )
            : ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 60,
                    ),
                  ),
                ),
                fixedSize: const WidgetStatePropertyAll(Size.infinite),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 1.7.h, horizontal: 16),
                ),
                splashFactory: InkRipple.splashFactory,
                overlayColor: WidgetStatePropertyAll(
                  AppColors.whiteColor.withValues(alpha: 0.15),
                ),
                backgroundColor: widget.isEnable!
                    ? WidgetStatePropertyAll(widget.color)
                    : WidgetStatePropertyAll(
                        AppColors.darkGrey.withValues(alpha: 0.3),
                      ),
                elevation: const WidgetStatePropertyAll(0),
              ),
        onPressed: widget.isEnable! ? widget.onTap : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.prefixIcon ?? const SizedBox(),
            widget.prefixIcon != null
                ? const SizedBox(width: 5)
                : const SizedBox(),
            Text(
              widget.title,
              style: !widget.isNegative!
                  ? widget.isEnable!
                      ? widget.titleStyle ?? AppStyling.medium14White
                      : AppStyling.medium14White
                  : widget.titleStyle ?? AppStyling.medium14Black,
            ),
          ],
        ),
      ),
    );
  }
}
