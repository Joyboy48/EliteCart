import 'package:studio_projects/Features/Shop/Screens/cart/cart.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

class cartCounterIcon extends StatelessWidget {
  const cartCounterIcon({
    super.key,
    required this.onPressed,
    required this.iconColor,
  });

  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return Stack(
      children: [
        IconButton(
          onPressed: () => Get.to(() => const MyCart()),
          icon: Icon(
            Iconsax.shopping_bag,
            color: iconColor,
          ),
        ),
        Positioned(
          right: 0,
          child: Obx(() {
            final count = cartController.itemCount;
            if (count == 0) return SizedBox.shrink();
            return Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: MyColors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: MyColors.white, fontSizeFactor: 0.8),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
