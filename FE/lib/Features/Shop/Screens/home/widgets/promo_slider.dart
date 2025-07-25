import 'package:carousel_slider/carousel_slider.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/circular_container.dart';
import 'package:studio_projects/Common/Widgets/images/rounded_images.dart';
import 'package:studio_projects/Features/Shop/Controller/home_controller.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class promoSlider extends StatelessWidget {
  const promoSlider({
    super.key, required this.banners,
  });

  final List<String> banners;
  @override
  Widget build(BuildContext context) {

    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          items: banners.map((url)=> RoundedImage(imageUrl: url)).toList(),
          options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, _)=> controller.updatePageIndicator(index)
          ),
        ),
        const SizedBox(height: MySize.spaceBtwItems,),
        Center(
          child: Obx(
                ()=> Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i= 0;i<banners.length ;i++) CircularContainer(
                  width: 20,
                  height: 4,
                  margin: const EdgeInsets.only(right: 10),
                  backgroundColor: controller.carousalCurrentIndex.value == i ? MyColors.primary : MyColors.grey,
                ),

              ],

            ),
          ),
        )
      ],
    );
  }
}