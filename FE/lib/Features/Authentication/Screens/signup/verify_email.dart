// import 'package:studio_projects/Common/Widgets/login_signup/success_screen.dart';
// import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
// import 'package:studio_projects/Utiles/constants/image_strings.dart';
// import 'package:studio_projects/Utiles/constants/size.dart';
// import 'package:studio_projects/Utiles/constants/texts_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class VerifyEmail extends StatelessWidget {
//   const VerifyEmail({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//               onPressed: () => Get.off(() => const loginPage()),
//               icon: const Icon(Icons.clear))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(MySize.defaultSpace),
//           child: Column(
//             children: [
//               ///Image
//               const Image(
//                 image: AssetImage(ImageStrings.cat1),
//               ),
//               const SizedBox(
//                 height: MySize.spaceBtwSection,
//               ),
//
//               ///Title subtitle
//               Text(
//                 TextsStrings.confirmEmail,
//                 style: Theme.of(context).textTheme.headlineMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: MySize.spaceBtwItems,
//               ),
//               Text(
//                 'qwert1234@gmail.com',
//                 style: Theme.of(context).textTheme.labelLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: MySize.spaceBtwItems,
//               ),
//               Text(
//                 TextsStrings.confirmEmailSubTitle,
//                 style: Theme.of(context).textTheme.labelMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: MySize.spaceBtwItems,
//               ),
//
//
//               ///Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(onPressed: ()=>Get.to(()=>const SuccessScreen()), child: const Text("Continue")),
//               ),
//               const SizedBox(
//                 height: MySize.spaceBtwItems,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: TextButton(onPressed: (){}, child: const Text(TextsStrings.resendEmail)),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:studio_projects/Common/Widgets/login_signup/success_screen.dart';
import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:studio_projects/Utiles/constants/texts_strings.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class VerifyEmail extends StatelessWidget {
  final String email;
  final String token;

  const VerifyEmail({super.key, required this.email, required this.token});

  Future<void> verifyUserEmail(BuildContext context) async {
    final Uri url = Uri.parse(
        '${ApiConstants.baseUrl}/users/verify-email?token=$token&email=$email');

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        Get.to(() => const SuccessScreen());
      } else {
        final decoded = jsonDecode(res.body);
        Get.snackbar("Error", decoded['message'] ?? 'Verification failed');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.off(() => const loginPage()),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySize.defaultSpace),
          child: Column(
            children: [
              const Image(image: AssetImage(ImageStrings.cat1)),
              const SizedBox(height: MySize.spaceBtwSection),
              Text(TextsStrings.confirmEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: MySize.spaceBtwItems),
              Text(email,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: MySize.spaceBtwItems),
              Text(TextsStrings.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: MySize.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => verifyUserEmail(context),
                    child: const Text("Continue")),
              ),
              const SizedBox(height: MySize.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      // optional: implement resend API here
                    },
                    child: const Text(TextsStrings.resendEmail)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
