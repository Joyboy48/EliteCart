import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Features/personalizaion/Screens/address/add_new_address.dart';
import 'package:studio_projects/Features/personalizaion/Screens/address/widget/single_address.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Utiles/HTTP/http_client.dart';
import '../../../../Utiles/Helpers/cookie_helper.dart';
//
// class UserAddressScreen extends StatelessWidget {
//   const UserAddressScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: ()=>Get.to(()=>const AddNewAddressScreen()),
//         backgroundColor: MyColors.primary,
//         child: const Icon(Iconsax.add,color: MyColors.white,),
//       ),
//       appBar: MyAppBar(
//         title: Text('Addresses',style: Theme.of(context).textTheme.headlineSmall,),
//         showBackArrow: true ,
//       ),
//       body: const SingleChildScrollView(
//         child: Padding(padding: EdgeInsets.all(MySize.defaultSpace),
//         child: Column(
//           children: [
//             SingleAddress(selectedAddress: true),
//             SingleAddress(selectedAddress: false),
//            ]
//         ),
//         ),
//       ),
//     );
//   }
// }

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  void fetchAddresses() async {
    final token = await getToken();
    try {
      final fetchedAddresses = await HttpHelper().getUserAddresses(token!);
      setState(() {
        addresses = fetchedAddresses;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Failed to load addresses");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNewAddressScreen(addressData: {}))?.then((_) => fetchAddresses()),
        backgroundColor: MyColors.primary,
        child: const Icon(Iconsax.add, color: MyColors.white),
      ),
      appBar: MyAppBar(
        title: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? const Center(child: Text("No addresses found"))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySize.defaultSpace),
          child: Column(
            children: addresses.map((addr) {
              return SingleAddress(
                selectedAddress: false,
                address: addr,
                onEdit: () {
                  Get.to(() => AddNewAddressScreen(addressData: addr))
                      ?.then((_) => fetchAddresses());
                },
                onDelete: () async {
                  final token = await getToken();
                  final result = await HttpHelper().deleteAddress(token!, addr['_id']);
                  if (result['statusCode'] == 200) {
                    Get.snackbar("Success", "Address deleted");
                    fetchAddresses();
                  } else {
                    Get.snackbar("Error", "Failed to delete address");
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}