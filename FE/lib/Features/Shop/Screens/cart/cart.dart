import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/products/cart/add_remove_button.dart';
import 'package:studio_projects/Common/Widgets/products/cart/cart_item.dart';
import 'package:studio_projects/Common/Widgets/texts/product_price_text.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Features/Shop/Screens/order/checkout_screen.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List products = [];
  bool isLoading = true;
  final CartController cartController = Get.find<CartController>();

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
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'My Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
              final cartItems = cartController.cartItems.value;
              final cartProducts = products
                  .where((product) => cartItems.any(
                      (item) => item.productId == product['_id']?.toString()))
                  .toList();
              if (cartProducts.isEmpty) {
                return const Center(child: Text('No products in cart'));
              }
              return ListView.separated(
                shrinkWrap: true,
                itemCount: cartProducts.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: MySize.spaceBtwSection),
                itemBuilder: (context, index) {
                  final product = cartProducts[index];
                  final productId = product['_id']?.toString() ?? '';
                  final cartItemData = cartItems
                      .firstWhereOrNull((item) => item.productId == productId);
                  final quantity = cartItemData?.quantity ?? 0;
                  final price = (product['price'] ?? 0) * quantity;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: cartItemData != null
                                ? cartItem(
                                    product: product,
                                    quantity: quantity,
                                  )
                                : SizedBox.shrink(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await cartController.removeFromCart(productId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Removed from cart'),
                                  backgroundColor: Colors.blue,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: MySize.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 60),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () async {
                                      if (cartItemData != null &&
                                          cartItemData.quantity > 1) {
                                        await cartController.updateCartItem(
                                            productId,
                                            cartItemData.quantity - 1);
                                      } else if (cartItemData != null) {
                                        await cartController
                                            .removeFromCart(productId);
                                      }
                                    },
                                  ),
                                  Text(quantity.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () async {
                                      if (cartItemData != null) {
                                        await cartController.updateCartItem(
                                            productId,
                                            cartItemData.quantity + 1);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          productPriceText(price: price.toString()),
                        ],
                      ),
                    ],
                  );
                },
              );
            }),
      bottomNavigationBar: Obx(() {
        final cartItems = cartController.cartItems.value;
        final cartProducts = products
            .where((product) => cartItems
                .any((item) => item.productId == product['_id']?.toString()))
            .toList();
        final total = cartProducts.fold<int>(0, (sum, product) {
          final productId = product['_id']?.toString() ?? '';
          final cartItemData =
              cartItems.firstWhereOrNull((item) => item.productId == productId);
          final quantity = cartItemData?.quantity ?? 0;
          final price = product['price'] ?? 0;
          final intPrice =
              (price is int) ? price : int.tryParse(price.toString()) ?? 0;
          final intQuantity = (quantity is int)
              ? quantity
              : int.tryParse(quantity.toString()) ?? 0;
          return sum + (intPrice * intQuantity);
        });
        return Padding(
          padding: const EdgeInsets.all(MySize.defaultSpace),
          child: ElevatedButton(
            onPressed: cartProducts.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          cartProducts: cartProducts,
                          total: total,
                        ),
                      ),
                    );
                  },
            child: Text('Checkout ₹$total'),
          ),
        );
      }),
    );
  }
}
