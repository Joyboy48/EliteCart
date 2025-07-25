import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
import 'package:studio_projects/Common/Widgets/products/sortable/sortable_product.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<dynamic> allProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    final response =
        await http.get(Uri.parse(ApiConstants.baseUrl + "/products/products"));
    print('Status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Fetched products: ' + response.body);
      setState(() {
        allProducts = data['data'] ?? [];
        allProducts.shuffle();
        isLoading = false;
      });
    } else {
      print('Failed to fetch products: ${response.body}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Popular Products'),
        showBackArrow: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(MySize.defaultSpace),
              child: Gridlayout(
                itemCount: allProducts.length,
                itemBuilder: (context, index) =>
                    ProductCardVertical(product: allProducts[index]),
              ),
            ),
    );
  }
}
