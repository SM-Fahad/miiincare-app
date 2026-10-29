import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/features/cart/controller/cart_controller.dart';
import 'package:miiincare/features/catalog/model/product_model.dart';
import 'package:miiincare/features/product/controller/product_controller.dart';
// import 'package:miiincare/routes/app_routes.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final initial = Get.arguments as ProductModel;
    final controller = Get.put(ProductController(initial), tag: initial.slug);
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController(), permanent: true);
    return Obx(() {
      final product = controller.product.value;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.background,
          title: const Text('Product details'),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 8),
          //     child: IconButton(
          //       tooltip: 'Open bag',
          //       onPressed: () => Get.offAllNamed(AppRoutes.checkout, arguments: 3),
          //       icon: const Icon(Icons.shopping_bag_outlined),
          //     ),
          //   ),
          // ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: product.stock <= 0 || cartController.isLoading.value
                  ? null
                  : () async {
                      final added = await cartController.add(product.id);
                      if (added) {
                        EasyLoading.showSuccess(
                          'Added to bag ${product.name}',
                          // duration: const Duration(seconds: 2),
                        );
                      }
                    },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text(
                product.stock <= 0
                    ? 'Out of stock'
                    : 'Add to bag · BDT ${product.price.toStringAsFixed(0)}',
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            if (controller.isLoading.value)
              const LinearProgressIndicator(minHeight: 2),
            _Gallery(controller: controller),
            const SizedBox(height: 22),
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: [
            //     if (product.isBestSeller)
            //       const Chip(label: Text('BEST SELLER')),
            //     Chip(
            //       label: Text(
            //         product.stock > 0
            //             ? '${product.stock} in stock'
            //             : 'OUT OF STOCK',
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 8),
            Text(
              product.tagline.toUpperCase(),
              style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 26,
                height: 1.15,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (product.size.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  product.size,
                  style: const TextStyle(color: AppColor.muted),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'BDT ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (product.compareAtPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'BDT ${product.compareAtPrice!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColor.muted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                const Spacer(),
                const Icon(Icons.star_rounded, color: Color(0xFFC68A1B)),
                Text(
                  '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                ),
              ],
            ),
            if (product.shortDescription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  product.shortDescription,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 22),
            _ProductAccordion(
              title: 'Description',
              isVisible: product.description.isNotEmpty,
              child: Text(
                product.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColor.muted,
                ),
              ),
            ),
            _ProductAccordion(
              title: 'Benefits',
              isVisible: product.benefits.isNotEmpty,
              child: _BulletList(items: product.benefits),
            ),
            _ProductAccordion(
              title: 'Ingredients',
              isVisible: product.ingredients.isNotEmpty,
              child: _BulletList(items: product.ingredients),
            ),
            _ProductAccordion(
              title: 'How to use',
              isVisible: product.howToUse.isNotEmpty,
              child: Text(
                product.howToUse,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColor.muted,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.controller});
  final ProductController controller;
  @override
  Widget build(BuildContext context) {
    final images = controller.gallery;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: images.isEmpty
                      ? const Icon(
                          Icons.spa_outlined,
                          size: 96,
                          color: AppColor.lavender,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: PageView.builder(
                            controller: controller.galleryPageController,
                            onPageChanged: controller.onImageChanged,
                            itemCount: images.length,
                            itemBuilder: (_, index) => Image.network(
                              images[index],
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.spa_outlined,
                                size: 96,
                                color: AppColor.lavender,
                              ),
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Image.asset(
                    'assets/icons/authentic.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (images.length > 1)
          SizedBox(
            height: 78,
            child: Center(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 12),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, index) => SizedBox.square(
                  dimension: 64,
                  child: InkWell(
                    onTap: () => controller.selectImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.softLavender,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedImage.value == index
                              ? AppColor.primary
                              : AppColor.border,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(images[index], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProductAccordion extends StatelessWidget {
  const _ProductAccordion({
    required this.title,
    required this.child,
    required this.isVisible,
  });

  final String title;
  final Widget child;
  final bool isVisible;

  @override
  Widget build(BuildContext context) => !isVisible
      ? const SizedBox.shrink()
      : Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColor.border)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 18),
              iconColor: AppColor.primary,
              collapsedIconColor: AppColor.ink,
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [Align(alignment: Alignment.centerLeft, child: child)],
            ),
          ),
        );
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) => Column(
    children: items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(Icons.circle, size: 6, color: AppColor.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColor.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}
