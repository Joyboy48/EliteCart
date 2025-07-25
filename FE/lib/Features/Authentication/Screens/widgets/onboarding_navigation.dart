import 'package:studio_projects/Utiles/Device/device_utility.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding_navigation extends StatelessWidget {
   const OnBoarding_navigation({
    super.key, required this.pageController,
  });

   final PageController pageController;


   @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Positioned(
        bottom: DeviceUtility.getBottomNavBarHeight(context) + 25,
        left: MySize.defaultSpace,
        child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: WormEffect(
              activeDotColor: dark ? MyColors.light : MyColors.dark ,
              dotHeight: 6,
            )
        ));
  }
}
