import 'dart:convert';

import 'package:studio_projects/Features/Authentication/Screens/password_config/forget_password.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:studio_projects/Utiles/constants/texts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Login/login.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class ResetPassword extends StatefulWidget {
  final String otpToken;

  const ResetPassword({super.key, required this.otpToken});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/users/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'otpToken': widget.otpToken,
        'otp': _otpController.text,
        'newPassword': _newPasswordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password reset successfully')));
      Get.off(() => loginPage());
    } else {
      final error = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySize.defaultSpace),
          child: Column(
            children: [
              ///Image
              const Image(image: AssetImage(ImageStrings.cat3)),
              const SizedBox(
                height: MySize.defaultSpace,
              ),

              ///Title and Subtitle
              Text(
                TextsStrings.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: MySize.defaultSpace,
              ),
              Text(
                TextsStrings.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: MySize.defaultSpace,
              ),
              Text("Spam Folder me check kerna mail 😅"),
              const SizedBox(
                height: MySize.defaultSpace,
              ),

              ///OTP Field
              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                ),
              ),
              const SizedBox(
                height: MySize.defaultSpace,
              ),

              ///New Password Field
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
                obscureText: true,
              ),

              const SizedBox(
                height: MySize.defaultSpace,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : const Text("Reset Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
