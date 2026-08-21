// ignore_for_file: file_names

import 'package:miiincare/core/common/style/global_text_style.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? maxLength;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final Color? fillColor;
  final Color? borderColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.errorText,
    this.fillColor,
    this.borderColor,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.contentPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword && widget.isPassword) {
      _obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      style: AppTextStyle.getTextStyle(
        fontSize: 16,
        color: AppColor.primaryFontColor,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyle.getTextStyle(
          fontSize: 14,
          color: AppColor.fieldFontColor,
        ),
        filled: true,
        fillColor: widget.fillColor ?? AppColor.textFieldFillColor,
        prefixIcon: widget.prefix,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.primaryFontColor,
                ),
              )
            : widget.suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColor.textFieldBorderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColor.textFieldBorderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColor.primaryButtonColor.withValues(alpha: 0.9),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.lavender),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.lavender),
        ),
        errorText: widget.errorText,
        counterText: '',
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );

    if ((widget.labelText ?? '').trim().isEmpty) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText!,
          style: AppTextStyle.getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryFontColor,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
