import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studio_projects/Features/Authentication/Screens/password_config/reset_password.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:studio_projects/Utiles/constants/texts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/users/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': _emailController.text}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final otpToken = data['data']['otpToken'];
      Get.to(() => ResetPassword(otpToken: otpToken));
    } else {
      final error = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(MySize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Heading
            Text(
              TextsStrings.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: MySize.spaceBtwItems,
            ),
            Text(
              TextsStrings.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(
              height: MySize.spaceBtwItems,
            ),

            ///Text Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: TextsStrings.email,
                prefixIcon: Icon(Iconsax.direct_right),
              ),
            ),
            const SizedBox(
              height: MySize.defaultSpace,
            ),

            ///Submit Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : const Text("Submit"),
                ))
          ],
        ),
      ),
    );
  }
}
