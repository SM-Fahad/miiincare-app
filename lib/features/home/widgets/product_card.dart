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
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                // color: AppColor.softLavender,
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.image.isEmpty
                  ? const Icon(
                      Icons.spa_outlined,
                      color: AppColor.lavender,
                      size: 52,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
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
                  child: Text(
                    'BDT ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
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
