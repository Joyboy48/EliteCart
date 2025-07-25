import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class sortabeProduct extends StatefulWidget {
  const sortabeProduct({super.key});

  @override
  State<sortabeProduct> createState() => _sortabeProductState();
}

class _sortabeProductState extends State<sortabeProduct> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse(ApiConstants.baseUrl + "/products/products"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['data'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                ///Dropdown
                DropdownButtonFormField(
                  items: [
                    'Name',
                    'Higher Price',
                    'Lower Price',
                    'Sale',
                    'Newest',
                    'Popular'
                  ]
                      .map((option) =>
                          DropdownMenuItem(value: option, child: Text(option)))
                      .toList(),
                  onChanged: (value) {},
                  decoration:
                      const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                ),
                const SizedBox(
                  height: MySize.spaceBtwItems,
                ),

                ///product
                Gridlayout(
                    itemCount: products.length,
                    itemBuilder: (context, index) =>
                        ProductCardVertical(product: products[index])),
              ],
            ),
          );
  }
}
