import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
import 'package:studio_projects/Common/Widgets/images/circular_images.dart';
import 'package:studio_projects/Common/Widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:studio_projects/Common/Widgets/texts/product_price_text.dart';
import 'package:studio_projects/Common/Widgets/texts/product_title_text.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/enums.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class ProductMetaData extends StatelessWidget {
  final dynamic product;
  const ProductMetaData({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final discount = product['discount']?.toString() ?? '0';
    final oldPrice = product['oldPrice']?.toString();
    final price = product['price']?.toString() ?? '0';
    final name = product['name'] ?? 'No Name';
    final stock = product['stock'];
    final stockInt = (stock is int)
        ? stock
        : (stock is String)
            ? int.tryParse(stock) ?? 0
            : 0;
    final inStock = stockInt > 0;
    String? getBrandLogo(dynamic product) {
      final brand = product['brandId'] ?? product['brand'];
      if (brand is Map && brand['logo'] != null) {
        return brand['logo'];
      }
      return null;
    }

    String getBrandName(dynamic product) {
      final brand = product['brandId'] ?? product['brand'];
      if (brand is Map && brand['name'] != null) {
        return brand['name'];
      }
      if (brand is String) {
        return brand;
      }
      return 'No Brand';
    }

    final brandLogo = getBrandLogo(product);
    final brandName = getBrandName(product);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Title
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(thickness: 1, height: 16),

        ///Stock Status
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              const ProductTitleText(title: 'Status', smallSize: true),
              const SizedBox(width: MySize.spaceBtwItems),
              Text(
                inStock ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color: inStock ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        ///Brand
        Row(
          children: [
            if (brandLogo != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircularImage(
                  image: brandLogo,
                  width: 32,
                  height: 32,
                  overlayColor: dark ? MyColors.white : MyColors.black,
                ),
              ),
            BrandTitleTextWithVerifiedIcon(
              title: brandName,
              brandTextSize: TextSizes.large,
            ),
          ],
        ),
        const SizedBox(height: 12),

        ///price and sale price
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (discount != '0')
              RoundedContainer(
                radius: MySize.sm,
                backgroundColor: MyColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                    horizontal: MySize.sm, vertical: MySize.xs),
                child: Text(
                  '$discount%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: MyColors.black),
                ),
              ),
            if (discount != '0') const SizedBox(width: MySize.spaceBtwItems),
            if (oldPrice != null)
              Text('₹$oldPrice',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      )),
            if (oldPrice != null) const SizedBox(width: 8),
            productPriceText(
              price: price,
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
