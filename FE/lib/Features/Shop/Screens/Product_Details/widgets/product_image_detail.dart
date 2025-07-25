import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/curved_edges/curved_edgesWidgets.dart';
import 'package:studio_projects/Common/Widgets/icons/circular_icon.dart';
import 'package:studio_projects/Common/Widgets/images/rounded_images.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';

class ProductImageSlider extends StatelessWidget {
  final dynamic product;
  const ProductImageSlider({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final images = (product['images'] is List)
        ? product['images']
        : (product['images'] is Map)
            ? (product['images'] as Map).values.toList()
            : [];
    final WishlistController wishlistController =
        Get.find<WishlistController>();
    final productId = product['_id']?.toString() ?? '';
    return ClipPath(
      child: CurvedEdgeWidget(
        child: Container(
          color: dark ? MyColors.darkerGrey : MyColors.light,
          child: Stack(
            children: [
              ///main large image slider
              SizedBox(
                height: 400,
                child: images.isNotEmpty
                    ? PageView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) => Center(
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : const Center(
                        child: Image(
                          image: AssetImage(ImageStrings.bat1),
                        ),
                      ),
              ),

              ///Appbar Icons
              MyAppBar(
                showBackArrow: true,
                actions: [
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        final wasWishlisted =
                            wishlistController.isWishlisted(productId);
                        wishlistController.toggleWishlist(productId);
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
                      child: CircularIcon(
                        icon: wishlistController.isWishlisted(productId)
                            ? Iconsax.heart5
                            : Iconsax.heart,
                        color: Colors.red,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
