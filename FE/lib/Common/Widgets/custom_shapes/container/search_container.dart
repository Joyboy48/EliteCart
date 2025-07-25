import 'package:studio_projects/Utiles/Device/device_utility.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class searchContainer extends StatelessWidget {
  const searchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: MySize.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: DeviceUtility.getScreenWidth(context),
          padding: const EdgeInsets.all(MySize.md),
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                      ? MyColors.dark
                      : MyColors.light
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(MySize.cardRadiusLg),
              border: showBorder ? Border.all(color: MyColors.grey) : null),
          child: Row(
            children: [
              Icon(
                icon,
                color: MyColors.darkGrey,
              ),
              const SizedBox(
                width: MySize.spaceBtwItems,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
