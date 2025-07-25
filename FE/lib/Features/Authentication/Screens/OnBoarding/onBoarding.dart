import 'package:studio_projects/Features/Authentication/Controller/controllers_onboarding.dart';
import 'package:studio_projects/Utiles/Device/device_utility.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:studio_projects/Utiles/constants/texts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingScreen extends StatelessWidget {
  const onBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
        body: Stack(
          children: [
            //horizontal scrolable pages

            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator ,
              children: const [
                OnBoardingPage(
                  images: ImageStrings.onBoardingImage1,
                  title: TextsStrings.onBoardingTitle1,
                  subTitle: TextsStrings.onBoaardingSubTitle1,
                ),
                OnBoardingPage(
                  images: ImageStrings.onBoardingImage2,
                  title: TextsStrings.onBoardingTitle2,
                  subTitle: TextsStrings.onBoaardingSubTitle2,
                ),
                OnBoardingPage(
                  images: ImageStrings.onBoardingImage3,
                  title: TextsStrings.onBoardingTitle3,
                  subTitle: TextsStrings.onBoaardingSubTitle3,
                ),
              ],
            ),

            //skip  button

            const OnBoardingSkip(),

            //dot navigation smoothpageindicator

            const OnboardingNavigation(),

            //Circular button

            const OnboardingNextButton()
          ],
        ));
  }
}





//---------------------------------------------------------------------------

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Positioned(
        bottom: DeviceUtility.getBottomNavBarHeight(context)+10,
        right: MySize.defaultSpace,
        child: ElevatedButton(
          onPressed: ()=> OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),
              backgroundColor: dark? MyColors.primary : Colors.black),
          child: const Icon(Iconsax.arrow_right_3),
        ));
  }
}



//-------------------------------------------------------------------------------


class OnboardingNavigation extends StatefulWidget {
  const OnboardingNavigation({
    super.key,
  });

  @override
  State<OnboardingNavigation> createState() => _OnboardingNavigationState();
}

class _OnboardingNavigationState extends State<OnboardingNavigation> {
  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = HelperFunctions.isDarkMode(context);
    return Positioned(
        bottom: DeviceUtility.getBottomNavBarHeight(context) + 30,
        left: MySize.defaultSpace,
        child: SmoothPageIndicator(

            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            count: 3,
            effect: WormEffect(
              activeDotColor:dark ? MyColors.light : MyColors.dark ,
              dotHeight: 6,
            )
        ));
  }
}


//--------------------------------------------------------------------------------


class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: DeviceUtility.getAppBarHeight(AppBar()),
        right: MySize.defaultSpace,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text('Skip'),
        ));
  }
}



//-------------------------------------------------------------------------------


class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.images,
    required this.title,
    required this.subTitle,
  });

  final String images, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySize.defaultSpace),
      child: Column(
        children: [
          Image(
            image: AssetImage(images),
            width: HelperFunctions.screenWidth() * 0.8,
            height: HelperFunctions.screenHeight() * 0.6,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: MySize.spaceBtwItems,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}