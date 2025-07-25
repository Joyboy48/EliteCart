import 'package:studio_projects/Utiles/Device/device_utility.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: DeviceUtility.getBottomNavBarHeight(context),
        right: MySize.defaultSpace,
        child: ElevatedButton(
          onPressed: (){},
          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
          child: const Icon(Iconsax.arrow_right_3),
        ));
  }
}
