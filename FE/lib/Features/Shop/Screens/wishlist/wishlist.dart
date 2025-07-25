import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/icons/circular_icon.dart';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
import 'package:studio_projects/Features/Shop/Screens/home/home.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List products = [];
  bool isLoading = true;
  final WishlistController wishlistController = Get.find<WishlistController>();

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
      print(response.body);
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
    // Filter products to only those in the wishlist
    final wishlistedProducts = products
        .where((product) =>
            wishlistController.isWishlisted(product['_id']?.toString() ?? ''))
        .toList();
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistedProducts.isEmpty
              ? const Center(child: Text('No products in wishlist'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(MySize.defaultSpace),
                    child: Column(
                      children: [
                        Gridlayout(
                          itemCount: wishlistedProducts.length,
                          itemBuilder: (_, index) {
                            final product = wishlistedProducts[index];
                            final productId = product['_id']?.toString() ?? '';
                            return ProductCardVertical(
                              product: product,
                              showDelete: true,
                              onDelete: () async {
                                await wishlistController
                                    .removeFromWishlist(productId);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
