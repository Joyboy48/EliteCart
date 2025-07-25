
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Utiles/HTTP/http_client.dart';
import '../../../../Utiles/Helpers/cookie_helper.dart';

// class AddNewAddressScreen extends StatelessWidget {
//   const AddNewAddressScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const MyAppBar(
//         showBackArrow: true,
//         title: Text('Add new address'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(padding: const EdgeInsets.all(MySize.defaultSpace),
//         child: Form(
//
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.user),labelText: 'Name',
//                 ),
//               ),
//               const SizedBox(height: MySize.spaceBtwInputField,),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.mobile),labelText: 'Phone Number',
//                 ),
//               ),
//               const SizedBox(height: MySize.spaceBtwInputField,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Iconsax.building_31),labelText: 'Street',
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: MySize.spaceBtwInputField,),
//                   Expanded(
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Iconsax.code),labelText: 'Postal Code',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: MySize.spaceBtwInputField,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Iconsax.building),labelText: 'City',
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: MySize.spaceBtwInputField,),
//                   Expanded(
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Iconsax.activity),labelText: 'State',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: MySize.spaceBtwInputField,),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.global),labelText: 'Country',
//                 ),
//               ),
//               const SizedBox(height: MySize.defaultSpace,),
//               SizedBox(width: double.infinity,
//               child: ElevatedButton(onPressed: (){}, child:const Text( 'Save')),),
//
//
//
//
//             ],
//           ),
//         ),),
//       ),
//     );
//   }
// }

class AddNewAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  const AddNewAddressScreen({super.key, required this.addressData});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final postalController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.addressData.isNotEmpty) {
      nameController.text = widget.addressData['name'] ?? '';
      phoneController.text = widget.addressData['phoneNumber'] ?? '';
      streetController.text = widget.addressData['street'] ?? '';
      postalController.text = widget.addressData['postalCode'] ?? '';
      cityController.text = widget.addressData['city'] ?? '';
      stateController.text = widget.addressData['state'] ?? '';
      countryController.text = widget.addressData['country'] ?? '';
    }
  }

  void _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await getToken();
    final addressData = {
      "name": nameController.text,
      "phoneNumber": phoneController.text,
      "street": streetController.text,
      "postalCode": postalController.text,
      "city": cityController.text,
      "state": stateController.text,
      "country": countryController.text,
    };

    final result = widget.addressData.isEmpty
        ? await HttpHelper().addAddress(token!, addressData)
        : await HttpHelper().updateAddress(token!, widget.addressData['_id'], addressData);

    if (result['statusCode'] == 200 || result['statusCode'] == 201) {
      Get.back();
      Get.snackbar("Success", widget.addressData.isEmpty ? "Address added" : "Address updated");
    } else {
      Get.snackbar("Error", "Failed: ${result['body']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(widget.addressData.isEmpty ? 'Add New Address' : 'Edit Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySize.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: nameController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Name'), validator: _required),
                SizedBox(height: MySize.spaceBtwInputField),
                TextFormField(controller: phoneController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: 'Phone Number'), validator: _required),
                SizedBox(height: MySize.spaceBtwInputField),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: streetController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building_31), labelText: 'Street'), validator: _required)),
                    SizedBox(width: MySize.spaceBtwInputField),
                    Expanded(child: TextFormField(controller: postalController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.code), labelText: 'Postal Code'), validator: _required)),
                  ],
                ),
                SizedBox(height: MySize.spaceBtwInputField),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: cityController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: 'City'), validator: _required)),
                    SizedBox(width: MySize.spaceBtwInputField),
                    Expanded(child: TextFormField(controller: stateController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.activity), labelText: 'State'), validator: _required)),
                  ],
                ),
                SizedBox(height: MySize.spaceBtwInputField),
                TextFormField(controller: countryController, decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'Country'), validator: _required),
                SizedBox(height: MySize.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _saveAddress, child: Text(widget.addressData.isEmpty ? 'Save' : 'Update')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.isEmpty ? 'Required' : null;
}
