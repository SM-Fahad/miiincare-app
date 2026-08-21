import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF7453A6);
  static const lavender = Color(0xFF9A7BC5);
  static const softLavender = Color(0xFFF1EBF8);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFFBFAFD);
  static const ink = Color(0xFF211B2B);
  static const muted = Color(0xFF716B79);
  static const border = Color(0xFFE8E2EC);
  static const success = Color(0xFF2B7A58);

  // Backwards-compatible aliases used by the existing shared widgets.
  static const primaryFontColor = ink;
  static const secondaryFontColor = muted;
  static const fieldFontColor = ink;
  static const textFieldFillColor = surface;
  static const textFieldBorderColor = border;
  static const primaryButtonColor = primary;
  static const gradient1 = softLavender;
  static const gradient2 = background;
}
