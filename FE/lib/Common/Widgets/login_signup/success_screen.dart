import 'package:studio_projects/Common/Styles/spaceing_style.dart';
import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:studio_projects/Utiles/constants/texts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: spaceingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              const Image(
                image: AssetImage(ImageStrings.cat2),
              ),
              const SizedBox(
                height: MySize.spaceBtwSection,
              ),

              ///Title subtitle
              Text(
                TextsStrings.youraccountcreatedfitte,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: MySize.spaceBtwItems,
              ),
              Text(
                TextsStrings.yourAccountCreatedSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: MySize.spaceBtwItems,
              ),
              const SizedBox(
                height: MySize.spaceBtwItems,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: ()=>Get.to(()=>const loginPage()), child: const Text("Continue")),
              ),
            ],
          ),
        ),

      ),
    );
  }
}