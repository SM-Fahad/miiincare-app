import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/features/best_sellers/controller/best_sellers_controller.dart';
import 'package:miiincare/features/home/widgets/product_card.dart';

class BestSellersScreen extends StatelessWidget {
  BestSellersScreen({super.key});

  final BestSellersController controller = Get.put(BestSellersController());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColor.background,
      title: const Text('Best sellers'),
    ),
    body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.error.value, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: controller.load,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        );
      }
      if (controller.products.isEmpty) {
        return const Center(child: Text('No best sellers available.'));
      }
      return RefreshIndicator(
        onRefresh: controller.load,
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: .62,
          ),
          itemCount: controller.products.length,
          itemBuilder: (_, index) =>
              ProductCard(product: controller.products[index]),
        ),
      );
    }),
  );
}
