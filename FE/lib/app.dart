import "package:studio_projects/Features/Authentication/Screens/OnBoarding/onBoarding.dart";

import "package:studio_projects/Utiles/theme/theme.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "navigation_menu.dart";

class App extends StatelessWidget {

  final bool isLoggedIn;

  const App({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lighttheme,
      darkTheme: AppTheme.darktheme,
      // home: const onBoardingScreen(),
      home: isLoggedIn ? NavigationMenu() : const onBoardingScreen(),


    );
  }
}

