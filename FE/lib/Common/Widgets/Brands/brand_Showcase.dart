import 'package:studio_projects/Common/Widgets/Brands/brand_Card.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({
    super.key,
    required this.images,
    required this.brandName,
    required this.brandImage,
    required this.stock,
  });

  final List<String> images;
  final String brandName;
  final String brandImage;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      borderColor: MyColors.darkGrey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(MySize.md),
      margin: const EdgeInsets.only(bottom: MySize.spaceBtwItems),
      child: Column(
        children: [
          ///Brand with product count
          BrandCard(
            showBorder: false,
            brandName: brandName,
            brandImage: brandImage,
            stock: stock,
          ),
          const SizedBox(
            height: MySize.spaceBtwItems,
          ),

          ///Brand top3 product
          Row(
              children: images
                  .map((image) => brandTopProductImageWidget(image, context))
                  .toList())
        ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: RoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(MySize.md),
        margin: const EdgeInsets.only(right: MySize.sm),
        backgroundColor: HelperFunctions.isDarkMode(context)
            ? MyColors.darkerGrey
            : MyColors.light,
        child: Image.network(image, fit: BoxFit.contain),
      ),
    );
  }
}
