
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/common/style/global_text_style.dart';
import 'package:miiincare/core/constants/app_color.dart';

class AppPageHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  const AppPageHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack ?? Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColor.primaryFontColor,
        ),
        Expanded(
          child: Text(
            title,
            style: AppTextStyle.getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }
}
