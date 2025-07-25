import 'package:studio_projects/Utiles/Device/device_utility.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: DeviceUtility.getAppBarHeight(AppBar()),
        right: MySize.defaultSpace,
        child: TextButton(onPressed: (){},child: const Text('Skip'),
        ));
  }
}