// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
// import 'package:studio_projects/Common/Widgets/images/circular_images.dart';
// import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
// import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
// import 'package:studio_projects/Features/personalizaion/Screens/profile/widget/profile_menu.dart';
// import 'package:studio_projects/Utiles/HTTP/http_client.dart';
// import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
// import 'package:studio_projects/Utiles/constants/image_strings.dart';
// import 'package:studio_projects/Utiles/constants/size.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   void logoutUser(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedToken = prefs.getString('token');
//
//     print("hi");
//
//     if (savedToken == null || savedToken.isEmpty || savedToken.split('.').length != 3) {
//       HelperFunctions.showSnackBar("Invalid or missing token. Please login again.");
//       return;
//     }
//
//     print("Logging out with token: $savedToken");
//
//     try {
//       final result = await HttpHelper.logout(savedToken);
//       print("Logout result: $result");
//
//       final status = result['statusCode'];
//       final body = result['body'];
//       final message = body['message'] ?? 'No message';
//
//       if (status == 200) {
//         HelperFunctions.showSnackBar("Logout successful: $message");
//         await prefs.remove('token');
//         Get.offAll(() => const loginPage());
//       } else {
//         HelperFunctions.showSnackBar("Logout failed: $message");
//       }
//     } catch (e) {
//       print("Logout error: $e");
//       HelperFunctions.showSnackBar("Logout failed: $e");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: const MyAppBar(
//         showBackArrow: true,
//         title: Text('Profile'),
//       ),
//       ///Body
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(MySize.defaultSpace),
//         child: Column(
//           children: [
//             ///profilePic
//             SizedBox(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   CircularImage(image: ImageStrings.userImage1,width: 80,height: 80,),
//                   TextButton(onPressed: (){}, child: const Text('Change Proflie Picture'))
//                 ],
//               ),
//             ),
//             ///Details
//             const SizedBox(height: MySize.spaceBtwItems/2,),
//             const Divider(),
//             const SizedBox(height: MySize.spaceBtwItems,),
//             const SectionHeading(title: 'Profile Information',showActionButton: false,),
//             const SizedBox(height: MySize.spaceBtwItems,),
//
//             ProfileMenu(onPressed: () {}, title: 'Name', value: 'Astitva Arya',),
//             ProfileMenu(onPressed: () {}, title: 'Username', value: 'astitva_arya',),
//             const SizedBox(height: MySize.spaceBtwItems,),
//             const Divider(),
//             const SizedBox(height: MySize.spaceBtwItems,),
//             const SectionHeading(title: 'Personal Information',showActionButton: false,),
//             const SizedBox(height: MySize.spaceBtwItems,),
//
//             ProfileMenu(onPressed: () {}, title: 'User ID',icon: Iconsax.copy, value: '696969',),
//             ProfileMenu(onPressed: () {}, title: 'E-mail', value: 'qwerty1234@gmail.com',),
//             ProfileMenu(onPressed: () {}, title: 'Phone Number', value: '+91-6853658363',),
//             ProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male',),
//             ProfileMenu(onPressed: () {}, title: 'Date of Birth', value: '02 Aug, 2004',),
//             const Divider(),
//
//             Center(
//               child: TextButton(onPressed:()=>logoutUser(context), child: const Text('Logout Account',style: TextStyle(color: Colors.red,fontSize: 15 ),)),
//             )
//
//           ],
//         ),
//       ),
//
//     );
//   }
// }
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_projects/Features/personalizaion/Screens/profile/widget/profile_menu.dart';

import '../../../../Common/Widgets/appBar/appBar.dart';
import '../../../../Common/Widgets/images/circular_images.dart';
import '../../../../Common/Widgets/texts/section_heading.dart';
import '../../../../Utiles/HTTP/http_client.dart';
import '../../../../Utiles/Helpers/helper_functions.dart';
import '../../../../Utiles/constants/image_strings.dart';
import '../../../../Utiles/constants/size.dart';
import '../../../Authentication/Screens/Login/login.dart';
import 'edit_profile.dart';
import 'package:http/http.dart' as http;
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    print('[Profile] Using token: ${savedToken ?? 'NO TOKEN FOUND'}');

    if (savedToken == null || savedToken.isEmpty) {
      setState(() {
        errorMessage = "Token not found. Please log in.";
        isLoading = false;
      });
      HelperFunctions.showSnackBar("Token not found. Please log in.");
      return;
    }

    try {
      final response = await HttpHelper().getUserProfile(savedToken);
      print("[Profile] Profile response: $response");

      if (response['statusCode'] == 200) {
        setState(() {
          profileData = response['body']['data']['user'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load profile. Status: " +
              response['statusCode'].toString() +
              "\nMessage: " +
              (response['body']['message']?.toString() ??
                  response['body'].toString());
          isLoading = false;
        });
        HelperFunctions.showSnackBar(errorMessage!);
      }
    } catch (e) {
      print("[Profile] Error fetching profile: $e");
      setState(() {
        errorMessage = "Error fetching profile: $e";
        isLoading = false;
      });
      HelperFunctions.showSnackBar("Error fetching profile: $e");
    }
  }

  void logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken == null ||
        savedToken.isEmpty ||
        savedToken.split('.').length != 3) {
      HelperFunctions.showSnackBar(
          "Invalid or missing token. Please login again.");
      return;
    }

    try {
      final result = await HttpHelper.logout(savedToken);
      final status = result['statusCode'];
      final body = result['body'];
      final message = body['message'] ?? 'No message';

      if (status == 200) {
        HelperFunctions.showSnackBar("Logout successful: $message");
        await prefs.remove('token');
        // Clear user-specific data
        final WishlistController wishlistController =
            Get.find<WishlistController>();
        final CartController cartController = Get.find<CartController>();
        wishlistController.clearWishlist();
        cartController.clearCartLocal();
        Get.offAll(() => const loginPage());
      } else {
        HelperFunctions.showSnackBar("Logout failed: $message");
      }
    } catch (e) {
      print("Logout error: $e");
      HelperFunctions.showSnackBar("Logout failed: $e");
    }
  }

  String formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr == '') return 'Not specified';
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMM, yyyy').format(date); // e.g. 10 Mar, 2004
    } catch (e) {
      return 'Invalid date';
    }
  }

  File? _pickedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      await uploadImage(_pickedImage!);
    }
  }

  Future<void> uploadImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      HelperFunctions.showSnackBar('Token missing. Please login.');
      return;
    }

    final response = await HttpHelper().uploadProfilePicture(token, imageFile);

    if (response['statusCode'] == 200) {
      fetchUserProfile();
      HelperFunctions.showSnackBar('Profile picture updated!');
    } else {
      HelperFunctions.showSnackBar(
          'Failed to upload image: ${response['body']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: fetchUserProfile,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(MySize.defaultSpace),
                  child: Column(
                    children: [
                      /// Profile Picture
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (profileData?['avatar'] != null &&
                                          profileData!['avatar'] != '' &&
                                          profileData!['avatar']
                                              .toString()
                                              .startsWith('http')
                                      ? NetworkImage(profileData!['avatar'])
                                          as ImageProvider
                                      : AssetImage(ImageStrings.userImage1)),
                            ),
                            TextButton(
                              onPressed: pickImage,
                              child: const Text('Change Profile Picture'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: MySize.spaceBtwItems / 2),
                      const Divider(),
                      const SizedBox(height: MySize.spaceBtwItems),

                      /// Profile Info with Edit Button
                      SectionHeading(
                        title: 'Profile Information',
                        showActionButton: true,
                        buttonTitle: "Edit Profile",
                        onPressed: () async {
                          final result = await Get.to(() =>
                              EditProfileScreen(profileData: profileData!));
                          if (result == true) {
                            fetchUserProfile();
                          }
                        },
                      ),
                      const SizedBox(height: MySize.spaceBtwItems),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'Name',
                        value:
                            "${profileData?['firstName'] ?? ''} ${profileData?['lastName'] ?? ''}",
                      ),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'Username',
                        value: profileData?['username']?.toString() ?? '',
                      ),
                      const SizedBox(height: MySize.spaceBtwItems),
                      const Divider(),
                      const SizedBox(height: MySize.spaceBtwItems),

                      /// Personal Information
                      // SectionHeading(
                      //   title: 'Profile Information',
                      //   showActionButton: true,
                      //   onPressed: () async {
                      //     final result = await Get.to(() => EditProfileScreen(profileData: profileData!));
                      //     if (result == true) {
                      //       fetchUserProfile(); // Refresh data after editing
                      //     }
                      //   },
                      // ),

                      const SizedBox(height: MySize.spaceBtwItems),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'User ID',
                        icon: Icons.copy,
                        value: profileData?['_id'] ?? '',
                      ),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'E-mail',
                        value: profileData?['email'] ?? '',
                      ),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'Phone Number',
                        value: profileData?['phoneNumber'] ?? '',
                      ),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'Gender',
                        value: profileData?['gender'] ?? 'Not specified',
                      ),
                      ProfileMenu(
                        onPressed: () {},
                        title: 'Date of Birth',
                        value: formatDate(profileData?['dateOfBirth']),
                      ),
                      const Divider(),

                      /// Logout
                      Center(
                        child: TextButton(
                          onPressed: () => logoutUser(context),
                          child: const Text(
                            'Logout Account',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
