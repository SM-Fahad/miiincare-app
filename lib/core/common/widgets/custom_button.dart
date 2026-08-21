
import 'package:miiincare/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 55,
    this.width,
    this.backgroundColor = AppColor.primaryButtonColor,
    this.foregroundColor = AppColor.secondaryFontColor,
    this.borderRadius = 12,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = (isLoading) ? null : onPressed;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: effectiveOnPressed,
        child: isLoading
            ? SizedBox(
                width: height * 0.4,
                height: height * 0.4,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Text(
                text,
                style:
                    textStyle ??
                    const TextStyle(
                      fontSize: 18,
                      color: AppColor.surface,
                    ),
              ),
      ),
    );
  }
}
