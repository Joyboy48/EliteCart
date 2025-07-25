import 'package:studio_projects/Common/Widgets/icons/circular_icon.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class productQuantityWithAddRemove extends StatelessWidget {
  const productQuantityWithAddRemove({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularIcon(icon:Iconsax.minus,
          width: 32,
          height: 32,
          size: MySize.md,
          color: HelperFunctions.isDarkMode(context)?MyColors.white:MyColors.black,
          backgroundColor: HelperFunctions.isDarkMode(context)?MyColors.darkerGrey:MyColors.light,
        ),
        const SizedBox(width: MySize.spaceBtwItems,),
        Text('2',style: Theme.of(context).textTheme.titleSmall,),
        const SizedBox(width: MySize.spaceBtwItems,),
        const CircularIcon(icon:Iconsax.add,
          width: 32,
          height: 32,
          size: MySize.md,
          color: MyColors.white,
          backgroundColor: MyColors.primary,
        ),
      ],
    );
  }
}