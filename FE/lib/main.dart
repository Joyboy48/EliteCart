import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_projects/main.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

Future<void> main() async {
  //Add widgets binding
  //init local storage
  //await native splash
  //initialise firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
  //     (FirebaseApp value) => Get.put(AuthenticationRepository()),
  //
  // );
  //Todo: initaialise authentication

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  Get.put(WishlistController());
  Get.put(CartController());
  runApp(SplashScreen(isLoggedIn: token != null));
}

class SplashScreen extends StatelessWidget {
  final bool isLoggedIn;

  const SplashScreen({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)), // Simulate loading
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return App(isLoggedIn: isLoggedIn);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
