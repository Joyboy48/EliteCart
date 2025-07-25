import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/primary_headerContainer.dart';
import 'package:studio_projects/Common/Widgets/list_tile/settings_menu_tile.dart';
import 'package:studio_projects/Common/Widgets/list_tile/user_profile_tile.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Features/Shop/Screens/cart/cart.dart';
import 'package:studio_projects/Features/Shop/Screens/order/order.dart';
import 'package:studio_projects/Features/personalizaion/Screens/address/address.dart';
import 'package:studio_projects/Features/personalizaion/Screens/profile/profile.dart';
import 'package:studio_projects/Features/personalizaion/Screens/setting/load%20data.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Utiles/HTTP/http_client.dart';
import '../../../../Utiles/Helpers/helper_functions.dart';
import '../../../../Utiles/constants/image_strings.dart';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';

// class SettingScreen extends StatelessWidget {
//   const SettingScreen({super.key});
//
//   Future<void> _navigateToProfileScreen(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//     Get.to(() => ProfileScreen());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ///header
//             primaryHeaderContainer(child: Column(
//               children: [
//                 ///appbar
//                 MyAppBar(title: Text('Account',
//                   style: Theme.of(context).textTheme.headlineMedium!.apply(color: MyColors.white),),
//                 ),
//                 //SizedBox(height: MySize.spaceBtwSection ,),
//                 ///userprofile
//                 userProfileTile(onPressed: ()=>_navigateToProfileScreen(context)),
//                 const SizedBox(height: MySize.spaceBtwSection,)
//               ],
//             ),),
//             ///body
//             Padding(padding: const EdgeInsets.all(MySize.defaultSpace),
//             child: Column(
//               children: [
//                 ///title
//                 const SectionHeading(title: "Account Setting",showActionButton: false,),
//                 //SizedBox(height: MySize.spaceBtwItems,),
//
//                 SettingsMenuTile(icon: Iconsax.safe_home, title:'My Address', subtitle: 'Set Shopping Delivery Address',onTap: ()=>Get.to(()=>const UserAddressScreen()),),
//                 SettingsMenuTile(icon: Iconsax.shopping_cart, title:'My cart', subtitle: 'Add,remove product and move to check out',onTap: ()=>Get.to(()=>const MyCart()),),
//                 SettingsMenuTile(icon: Iconsax.bag_tick, title:'My order', subtitle: 'In-Prograss and Completed orders',onTap: ()=>Get.to(()=>const OrderScreen()),),
//                 SettingsMenuTile(icon: Iconsax.bank, title:'Bank Account', subtitle: 'Withdraw Balance to registered bank account',onTap: (){},),
//                 SettingsMenuTile(icon: Iconsax.discount_shape, title:'My coupons', subtitle: 'List of all discount Coupons',onTap: (){},),
//                 SettingsMenuTile(icon: Iconsax.notification, title:'Notifications', subtitle: 'Set any kind of notification message',onTap: (){},),
//                 SettingsMenuTile(icon: Iconsax.security_card, title:'Account Privacy', subtitle: 'Manage data usage and connected accounts',onTap: (){},),
//
//                 ///app setings
//                 const SizedBox(height: MySize.spaceBtwSection,),
//                 const SectionHeading(title: 'App Settings',showActionButton: false,),
//                 const SizedBox(height: MySize.spaceBtwItems,),
//                 SettingsMenuTile(icon: Iconsax.document_upload, title:'Load Data', subtitle: 'Upload data to your cloud Firestore',onTap: (){},),
//                 SettingsMenuTile(icon: Iconsax.location,trailing: Switch(value: true, onChanged: (value){}), title:'Geolocation ', subtitle: 'Set recommendation based on location'),
//                 SettingsMenuTile(icon: Iconsax.security_user,trailing: Switch(value: false, onChanged: (value){}), title:'Safe mode', subtitle: 'Search result is safe for all users',),
//                 SettingsMenuTile(icon: Iconsax.image,trailing: Switch(value: false, onChanged: (value){}), title:'HD Image quality', subtitle: 'Set image quality to be seen',),
//
//
//               ],
//             ),),
//
//           ],
//         ),
//       ),
//     );}
//   }

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken == null || savedToken.isEmpty) {
      HelperFunctions.showSnackBar("Token not found. Please log in.");
      return;
    }

    try {
      final response = await HttpHelper().getUserProfile(savedToken);
      if (response['statusCode'] == 200) {
        setState(() {
          profileData = response['body']['data']['user'];
          isLoading = false;
        });
      } else {
        HelperFunctions.showSnackBar("Failed to load profile.");
      }
    } catch (e) {
      HelperFunctions.showSnackBar("Error fetching profile: $e");
    }
  }

  Future<void> _navigateToProfileScreen(BuildContext context) async {
    Get.to(() => const ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// Header with profile info
                  primaryHeaderContainer(
                    child: Column(
                      children: [
                        MyAppBar(
                          title: Text(
                            'Account',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(color: MyColors.white),
                          ),
                        ),
                        // User profile tile with avatar, name, and email
                        ListTile(
                          onTap: () => _navigateToProfileScreen(context),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: profileData?['avatar'] != null &&
                                    profileData!['avatar'] != ''
                                ? NetworkImage(profileData!['avatar'])
                                : AssetImage(ImageStrings.userImage1)
                                    as ImageProvider,
                          ),
                          title: Text(
                            "${profileData?['firstName'] ?? ''} ${profileData?['lastName'] ?? ''}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            profileData?['email'] ?? '',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                        const SizedBox(height: MySize.spaceBtwSection),
                      ],
                    ),
                  ),

                  ///body
                  Padding(
                    padding: const EdgeInsets.all(MySize.defaultSpace),
                    child: Column(
                      children: [
                        ///title
                        const SectionHeading(
                          title: "Account Setting",
                          showActionButton: false,
                        ),
                        SettingsMenuTile(
                          icon: Iconsax.safe_home,
                          title: 'My Address',
                          subtitle: 'Set Shopping Delivery Address',
                          onTap: () => Get.to(() => const UserAddressScreen()),
                        ),
                        SettingsMenuTile(
                          icon: Iconsax.shopping_cart,
                          title: 'My cart',
                          subtitle: 'Add,remove product and move to check out',
                          onTap: () => Get.to(() => const MyCart()),
                        ),
                        SettingsMenuTile(
                          icon: Iconsax.bag_tick,
                          title: 'My order',
                          subtitle: 'In-Prograss and Completed orders',
                          onTap: () => Get.to(() => const OrderScreen()),
                        ),
                        SettingsMenuTile(
                          icon: Iconsax.bank,
                          title: 'Bank Account',
                          subtitle:
                              'Withdraw Balance to registered bank account',
                          onTap: () {},
                        ),
                        const SizedBox(height: MySize.spaceBtwSection),
                        const SectionHeading(
                          title: 'App Settings',
                          showActionButton: false,
                        ),
                        const SizedBox(height: MySize.spaceBtwItems),
                        SettingsMenuTile(
                          icon: Iconsax.document_upload,
                          title: 'Load Data',
                          subtitle: 'Upload data ',
                          onTap: () => Get.to(() => AddProductScreen()),
                        ),
                        const SizedBox(height: MySize.spaceBtwSection),
                        const SectionHeading(
                          title: 'App Preferences',
                          showActionButton: false,
                        ),
                        SettingsMenuTile(
                          icon: Icons.brightness_6,
                          title: 'Theme',
                          subtitle: Get.isDarkMode ? 'Dark' : 'Light',
                          trailing: Switch(
                            value: Get.isDarkMode,
                            onChanged: (val) {
                              if (val) {
                                Get.changeThemeMode(ThemeMode.dark);
                              } else {
                                Get.changeThemeMode(ThemeMode.light);
                              }
                              setState(() {}); // To update the subtitle
                            },
                          ),
                        ),
                        const SizedBox(height: MySize.spaceBtwSection),
                        const SectionHeading(
                          title: 'Support & Info',
                          showActionButton: false,
                        ),
                        SettingsMenuTile(
                          icon: Icons.info_outline,
                          title: 'About App',
                          subtitle: 'Version, privacy, terms',
                          onTap: () {
                            // TODO: Show about dialog
                            showAboutDialog(
                              context: context,
                              applicationName: 'Studio Projects',
                              applicationVersion: '1.0.0',
                              applicationLegalese: '© 2025 Studio Projects',
                            );
                          },
                        ),
                        const SizedBox(height: MySize.spaceBtwSection),
                        const SectionHeading(
                          title: 'Feedback',
                          showActionButton: false,
                        ),
                        SettingsMenuTile(
                          icon: Icons.feedback_outlined,
                          title: 'Send Feedback',
                          subtitle: 'Let us know your thoughts',
                          onTap: () async {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'support@yourapp.com',
                              query: 'subject=App Feedback',
                            );
                            // ignore: deprecated_member_use
                            await launch(emailLaunchUri.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
