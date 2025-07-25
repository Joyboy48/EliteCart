import 'package:studio_projects/Common/Widgets/images/rounded_images.dart';
import 'package:studio_projects/Common/Widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:studio_projects/Common/Widgets/texts/product_title_text.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/product_details.dart';
import 'package:iconsax/iconsax.dart';

class cartItem extends StatelessWidget {
  final dynamic product;
  final int quantity;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const cartItem({
    super.key,
    required this.product,
    required this.quantity,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final images = (product['images'] is List)
        ? product['images']
        : (product['images'] is Map)
            ? (product['images'] as Map).values.toList()
            : [];
    final imageUrl = images.isNotEmpty ? images[0] : ImageStrings.bat1;
    final brand = product['brandId'] ?? product['brand'] ?? {};
    final brandName = brand is Map ? (brand['name'] ?? '') : brand.toString();
    final brandLogo = brand is Map ? brand['logo'] : null;
    final productName = product['name'] ?? 'No Name';
    final color = product['color'] ?? '-';
    final size = product['size'] ?? '-';
    final price = product['price'] ?? 0;
    final dark = HelperFunctions.isDarkMode(context);
    final primary = MyColors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white, // Always white background
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                GestureDetector(
                  onTap: onTap ??
                      () => Get.to(
                          () => ProductDetails(productId: product['_id'])),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: RoundedImage(
                        imageUrl: imageUrl,
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.zero,
                        backgroundColor:
                            dark ? MyColors.darkerGrey : MyColors.light,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 4),
                      // Brand Row
                      Row(
                        children: [
                          if (brandLogo != null)
                            Image.network(
                              brandLogo,
                              width: 18,
                              height: 18,
                            ),
                          if (brandLogo != null) const SizedBox(width: 6),
                          Text(
                            brandName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Attributes as chips
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('Color: $color',
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('Size: $size',
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Quantity and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Qty: $quantity',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            '₹$price',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Delete Icon (floating, top right)
          if (onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Iconsax.trash, color: Colors.red, size: 22),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
