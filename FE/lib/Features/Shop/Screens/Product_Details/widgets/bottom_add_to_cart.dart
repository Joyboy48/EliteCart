import 'package:studio_projects/Common/Widgets/icons/circular_icon.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

class BottomAddToCart extends StatefulWidget {
  final dynamic product;
  const BottomAddToCart({super.key, required this.product});

  @override
  State<BottomAddToCart> createState() => _BottomAddToCartState();
}

class _BottomAddToCartState extends State<BottomAddToCart> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final CartController cartController = Get.find<CartController>();
    final productId = widget.product != null && widget.product['_id'] != null
        ? widget.product['_id'].toString()
        : '';
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: MySize.spaceBtwItems, vertical: MySize.spaceBtwItems / 2),
      decoration: BoxDecoration(
        color: dark ? MyColors.darkerGrey : MyColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(MySize.cardRadiusLg),
          topRight: Radius.circular(MySize.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (quantity > 1) quantity--;
                  });
                },
                child: const CircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: MyColors.darkGrey,
                  width: 40,
                  height: 40,
                  color: MyColors.white,
                ),
              ),
              const SizedBox(
                width: MySize.spaceBtwItems,
              ),
              Text(
                quantity.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                width: MySize.spaceBtwItems,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: const CircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: MyColors.black,
                  width: 40,
                  height: 40,
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                if (productId.isNotEmpty) {
                  await cartController.addToCart(productId, quantity,
                      (widget.product['price'] as num).toDouble());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added $quantity to cart'),
                      backgroundColor: Colors.blue,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(MySize.md),
                  backgroundColor: MyColors.black,
                  side: const BorderSide(color: MyColors.black)),
              child: const Text('Add to Cart'))
        ],
      ),
    );
  }
}
