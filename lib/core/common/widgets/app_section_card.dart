import 'package:flutter/material.dart';

class AppSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const AppSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderRadius,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? const Color(0xFFDDE4EA)),
        boxShadow:
            boxShadow ??
            const [
              BoxShadow(
                color: Color(0x0F101828),
                blurRadius: 20,
                offset: Offset(0, 6),
              ),
            ],
      ),
      child: child,
    );
  }
}
