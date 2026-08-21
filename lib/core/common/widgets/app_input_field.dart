import 'package:flutter/material.dart';
import 'package:miiincare/core/common/style/global_text_style.dart';
import 'package:miiincare/core/constants/app_color.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          obscureText: obscureText,
          onTap: onTap,
          readOnly: readOnly,
          style: AppTextStyle.getTextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.getTextStyle(
              fontSize: 15,
              color: AppColor.fieldFontColor,
            ),
            filled: true,
            fillColor: AppColor.textFieldFillColor,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 20 : 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColor.textFieldBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColor.primaryButtonColor,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
