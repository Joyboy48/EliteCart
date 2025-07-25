import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
import 'package:studio_projects/Common/Widgets/icons/circular_icon.dart';
import 'package:studio_projects/Common/Widgets/images/rounded_images.dart';
import 'package:studio_projects/Common/Widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:studio_projects/Common/Widgets/texts/product_price_text.dart';
import 'package:studio_projects/Common/Widgets/texts/product_title_text.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/product_details.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

class ProductCardHorizontal extends StatelessWidget {
  final dynamic product;
  const ProductCardHorizontal({super.key, required this.product});

  String getBrandName(dynamic product) {
    final brand = product['brand'] ?? product['brandId'];
    if (brand is Map && brand['name'] != null) {
      return brand['name'];
    }
    if (brand is String) {
      return brand;
    }
    return '';
  }

  String? getBrandLogo(dynamic product) {
    final brand = product['brand'] ?? product['brandId'];
    if (brand is Map && brand['logo'] != null) {
      return brand['logo'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final images = (product['images'] is List)
        ? product['images']
        : (product['images'] is Map)
            ? (product['images'] as Map).values.toList()
            : [];
    final imageUrl =
        images.isNotEmpty ? images[0] : 'https://via.placeholder.com/150';
    final productName = product['name']?.toString() ?? '';
    final productPrice = product['price']?.toString() ?? '0';
    final productId = product['_id']?.toString() ?? '';
    final CartController cartController = Get.find<CartController>();
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetails(productId: product['_id'])),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dark ? MyColors.darkerGrey : MyColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image with overlays
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Discount badge (top left)
                    if (product['discount'] != null &&
                        product['discount'].toString().isNotEmpty)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product['discount']}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProductTitleText(
                        title: productName,
                        smallSize: true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (getBrandLogo(product) != null)
                            Image.network(
                              getBrandLogo(product)!,
                              width: 20,
                              height: 20,
                            ),
                          const SizedBox(width: 8),
                          BrandTitleTextWithVerifiedIcon(
                            title: getBrandName(product),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price and add-to-cart button
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    productPriceText(price: productPrice),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: MyColors.dark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await cartController.addToCart(productId, 1,
                              (product['price'] as num).toDouble());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              backgroundColor: Colors.blue,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(
                            child: Icon(
                              Iconsax.add,
                              color: MyColors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Heart icon (floating higher above top right corner of card)
          Positioned(
            top: -15,
            right: -12,
            child: Obx(() {
              final WishlistController wishlistController =
                  Get.find<WishlistController>();
              return GestureDetector(
                onTap: () async {
                  final wasWishlisted =
                      wishlistController.isWishlisted(productId);
                  await wishlistController.toggleWishlist(productId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        wasWishlisted
                            ? 'Removed from wishlist'
                            : 'Added to wishlist',
                      ),
                      backgroundColor: Colors.blue,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: CircularIcon(
                    icon: wishlistController.isWishlisted(productId)
                        ? Iconsax.heart5
                        : Iconsax.heart,
                    color: Colors.red,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
