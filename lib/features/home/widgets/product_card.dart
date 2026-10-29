import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miiincare/core/constants/app_color.dart';
import 'package:miiincare/features/catalog/model/product_model.dart';
import 'package:miiincare/routes/app_routes.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () => Get.toNamed(AppRoutes.product, arguments: product),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.all(7),
                  child: product.image.isEmpty
                      ? const Icon(
                          Icons.spa_outlined,
                          color: AppColor.lavender,
                          size: 52,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.spa_outlined,
                              color: AppColor.lavender,
                              size: 52,
                            ),
                          ),
                        ),
                ),
                if (product.isBundle ||
                    product.isBestSeller ||
                    (product.compareAtPrice != null &&
                        product.compareAtPrice! > product.price))
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: product.isBundle
                            ? const Color(0xFF2B7A58)
                            : (product.isBestSeller
                                ? AppColor.primary
                                : const Color(0xFFC68A1B)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.isBundle
                            ? 'COMBO'
                            : (product.isBestSeller ? 'BESTSELLER' : 'SALE'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 5, 11, 2),
            child: Text(
              product.tagline.isEmpty
                  ? product.category.toUpperCase()
                  : product.tagline.toUpperCase(),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColor.muted,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: AppColor.ink,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 6, 11, 12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '৳${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColor.ink,
                        ),
                      ),
                      if (product.compareAtPrice != null &&
                          product.compareAtPrice! > product.price) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '৳${product.compareAtPrice!.toStringAsFixed(0)}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 10.5,
                              color: AppColor.muted,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.star_rounded,
                  size: 15,
                  color: Color(0xFFC68A1B),
                ),
                Text(
                  ' ${product.rating.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 11, color: AppColor.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
