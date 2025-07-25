import 'package:studio_projects/Common/Styles/shadows.dart';
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
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

class ProductCardVertical extends StatelessWidget {
  final dynamic product;
  final bool showDelete;
  final VoidCallback? onDelete;
  const ProductCardVertical({
    super.key,
    required this.product,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final WishlistController wishlistController =
        Get.find<WishlistController>();
    final CartController cartController = Get.find<CartController>();
    final productId = product['_id']?.toString() ?? '';
    // Fix: Ensure images is always a List
    final images = (product['images'] is List)
        ? product['images']
        : (product['images'] is Map)
            ? (product['images'] as Map).values.toList()
            : [];
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetails(productId: productId)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(MySize.productImageRadius),
          color: dark ? MyColors.darkerGrey : MyColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///thumbnail-- discount--wishlist
            RoundedContainer(
              height: 150,
              padding: const EdgeInsets.all(MySize.sm),
              backgroundColor: dark ? MyColors.dark : MyColors.light,
              child: Stack(
                children: [
                  //image
                  RoundedImage(
                    imageUrl: images.isNotEmpty
                        ? images[0]
                        : 'https://via.placeholder.com/150',
                    applyImageRadius: true,
                  ),
                  //-sale tag
                  Positioned(
                    top: 10,
                    child: RoundedContainer(
                      radius: MySize.sm,
                      backgroundColor: MyColors.secondary.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: MySize.sm, vertical: MySize.xs),
                      child: Text(
                        (product['discount']?.toString() ?? '0') + '%',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: MyColors.black),
                      ),
                    ),
                  ),

                  ///fav icon
                  Positioned(
                    top: 0,
                    right: 0,
                    child: showDelete
                        ? GestureDetector(
                            onTap: onDelete,
                            child: const CircularIcon(
                              icon: Iconsax.close_circle,
                              color: Colors.red,
                              size: 18,
                            ),
                          )
                        : Obx(() => GestureDetector(
                              onTap: () async {
                                final wasWishlisted =
                                    wishlistController.isWishlisted(productId);
                                await wishlistController
                                    .toggleWishlist(productId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      wasWishlisted
                                          ? 'Removed from wishlist'
                                          : 'Added to wishlist',
                                    ),
                                    backgroundColor: wasWishlisted
                                        ? Colors.grey[800]
                                        : Colors.blue,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: CircularIcon(
                                icon: wishlistController.isWishlisted(productId)
                                    ? Iconsax.heart5
                                    : Iconsax.heart,
                                color: Colors.red,
                                size: 18,
                              ),
                            )),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: MySize.spaceBtwItems / 2,
            ),

            ///details-
            Padding(
              padding: const EdgeInsets.only(left: MySize.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleText(
                    title: product['name'] ?? 'No Name',
                    smallSize: true,
                  ),
                  const SizedBox(
                    height: MySize.spaceBtwItems / 2,
                  ),
                  Row(
                    children: [
                      if (product['brandId']?['logo'] != null)
                        Image.network(
                          product['brandId']!['logo'],
                          width: 20,
                          height: 20,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        product['brandId']?['name'] ?? 'No Brand',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  productPriceText(
                    price: product['price']?.toString() ?? '0',
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: MyColors.dark,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(MySize.cardRadiusMd),
                          bottomRight:
                              Radius.circular(MySize.productImageRadius)),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await cartController.addToCart(
                            productId, 1, (product['price'] as num).toDouble());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            backgroundColor: Colors.blue,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const SizedBox(
                          width: MySize.iconLg,
                          height: MySize.iconLg,
                          child: Center(
                            child: Icon(
                              Iconsax.add,
                              color: MyColors.white,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
