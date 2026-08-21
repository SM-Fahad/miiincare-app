import 'package:miiincare/core/common/style/global_text_style.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final String? title;

  const CustomAppBar({super.key, this.onBack, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: onBack ?? () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new),
        color: AppColor.primaryFontColor,
      ),
      titleSpacing: 0,
      title: (title ?? '').trim().isEmpty
          ? null
          : Text(
              title!,
              style: AppTextStyle.getTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
