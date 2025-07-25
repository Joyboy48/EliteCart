import 'package:studio_projects/Features/Shop/Screens/home/home.dart';
import 'package:studio_projects/Features/Shop/Screens/store/store.dart';
import 'package:studio_projects/Features/Shop/Screens/wishlist/wishlist.dart';
import 'package:studio_projects/Features/personalizaion/Screens/setting/setting_screen.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = HelperFunctions.isDarkMode(context);
    return Scaffold(
       bottomNavigationBar: Obx(
         ()=> NavigationBar(
           height: 70,
           elevation: 0,
           selectedIndex: controller.selectedIndex.value,
           backgroundColor: darkMode?MyColors.black:MyColors.white ,
           indicatorColor: darkMode?MyColors.white.withOpacity(0.1):MyColors.black.withOpacity(0.1),
           onDestinationSelected: (index)=> controller.selectedIndex.value=index,
           destinations: const [
           NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
           NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
           NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
           NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),

         ],),
       ),
      body: Obx(()=> controller.screen[controller.selectedIndex.value]),
    );
  }
}

// class NavigationController extends GetxController{
//   final Rx<int> selectedIndex = 0.obs ;
//
//   final screen = [const HomeScreen(), Container(color: Colors.purple,),Container(color: Colors.orange,),Container(color: Colors.blue,),];
// }

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  List<Widget> get screen => [
    const HomeScreen(),const Store(),
    const Wishlist(),
    const SettingScreen(),
  ];
}
