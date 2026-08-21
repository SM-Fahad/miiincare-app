import 'package:miiincare/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle getTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColor.primaryFontColor,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor, 
    double? decorationThickness, 
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: 'SourceSans',
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decoration != null && decoration != TextDecoration.none ? (decorationThickness ?? 2) : null,
    );
  }
}
