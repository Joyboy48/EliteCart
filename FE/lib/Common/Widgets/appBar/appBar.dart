// import 'package:studio_projects/Utiles/Device/device_utility.dart';
// import 'package:studio_projects/Utiles/constants/size.dart';
// import 'package:studio_projects/app.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:iconsax/iconsax.dart';
//
// class AppBar extends StatelessWidget implements PreferredSizeWidget {
//   const AppBar(
//       {super.key,
//       this.title,
//       required this.actions,
//       this.leadingIcon,
//       this.leadingOnPressed,
//       this.showBackArrow = true});
//
//   final Widget? title;
//   final bool showBackArrow;
//   final IconData? leadingIcon;
//   final List<Widget> actions;
//   final VoidCallback? leadingOnPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: MySize.md),
//         child: AppBar(automaticallyImplyLeading = false,
//             leading: showBackArrow
//                 ? IconButton(
//                     onPressed: () => Get.back(),
//                     icon: const Icon(Iconsax.arrow_left))
//                 : leadingIcon != null ? IconButton(
//                     onPressed: leadingOnPressed, icon: Icon(leadingIcon)):null,
//         title: title,
//           actions: actions,
//         ));
//   }
//
//   @override
//   Size get preferredSize =>
//       Size.fromHeight(DeviceUtility.getAppBarHeight(AppBar()));
// }

import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Renamed to MyAppBar
  const MyAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.actions = const [],
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget> actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MySize.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Iconsax.arrow_left,
                    color: dark ? Colors.white : MyColors.dark),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(leadingIcon),
                  )
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
