import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/local_storage/storage_utility.dart';
import 'package:studio_projects/Features/personalizaion/Screens/address/add_new_address.dart';
import 'package:studio_projects/Features/Shop/Controller/cart_controller.dart';
import 'package:studio_projects/Features/Shop/Screens/order/order.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class CheckoutScreen extends StatefulWidget {
  final List cartProducts;
  final int total;
  const CheckoutScreen(
      {super.key, required this.cartProducts, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> addresses = [];
  String? selectedAddressId;
  bool isLoading = true;
  bool isSubmitting = false;
  late List<Map<String, dynamic>> products;
  int total = 0;

  @override
  void initState() {
    super.initState();
    products = List<Map<String, dynamic>>.from(widget.cartProducts);
    total = _calculateTotal();
    fetchAddresses();
  }

  int _calculateTotal() {
    int sum = 0;
    for (final p in products) {
      final price = (p['price'] as num?)?.toInt() ?? 0;
      final qty = int.tryParse(p['quantity']?.toString() ?? '1') ?? 1;
      sum += price * qty;
    }
    return sum;
  }

  void _updateTotal() {
    setState(() {
      total = _calculateTotal();
    });
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      int qty =
          int.tryParse(products[index]['quantity']?.toString() ?? '1') ?? 1;
      qty += delta;
      if (qty < 1) qty = 1;
      products[index]['quantity'] = qty;
      _updateTotal();
    });
  }

  void _removeProduct(int index) {
    setState(() {
      products.removeAt(index);
      _updateTotal();
    });
  }

  Future<void> fetchAddresses() async {
    setState(() => isLoading = true);
    final token = await LocalStorage().getToken();
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/users/addresses'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          addresses = List<Map<String, dynamic>>.from(data['addresses'] ?? []);
          if (addresses.isNotEmpty) selectedAddressId = addresses[0]['_id'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> submitOrder() async {
    if (selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a shipping address.')),
      );
      return;
    }
    setState(() => isSubmitting = true);
    final token = await LocalStorage().getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to checkout.')),
      );
      setState(() => isSubmitting = false);
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/orders/checkout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'shippingAddress': selectedAddressId,
          'products': products
              .map((p) => {
                    'product': p['_id'],
                    'quantity':
                        int.tryParse(p['quantity']?.toString() ?? '1') ?? 1,
                  })
              .toList(),
        }),
      );
      if (response.statusCode == 201) {
        // Clear cart in UI
        final cartController = Get.find<CartController>();
        await cartController.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrderScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product Summary Section
                    const Text('Order Summary',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    if (products.isEmpty)
                      const Text('No products in your order.'),
                    if (products.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final images = (product['images'] is List)
                              ? product['images']
                              : (product['images'] is Map)
                                  ? (product['images'] as Map).values.toList()
                                  : [];
                          final imageUrl = images.isNotEmpty
                              ? images[0]
                              : 'https://via.placeholder.com/80';
                          final name = product['name']?.toString() ?? '';
                          final price =
                              (product['price'] as num?)?.toInt() ?? 0;
                          final qty = int.tryParse(
                                  product['quantity']?.toString() ?? '1') ??
                              1;
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(imageUrl,
                                    width: 48, height: 48, fit: BoxFit.cover),
                              ),
                              title: Text(name,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Row(
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _changeQuantity(index, -1),
                                  ),
                                  Text('$qty'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => _changeQuantity(index, 1),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('₹${price * qty}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _removeProduct(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Shipping Address',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddNewAddressScreen(
                                          addressData: {})),
                            );
                            fetchAddresses();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add New'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (addresses.isEmpty)
                      const Text('No addresses found. Please add one.'),
                    if (addresses.isNotEmpty)
                      ...addresses.map((addr) => Card(
                            color: selectedAddressId == addr['_id']
                                ? Colors.blue.shade50
                                : null,
                            child: RadioListTile<String>(
                              value: addr['_id'],
                              groupValue: selectedAddressId,
                              onChanged: (val) {
                                setState(() => selectedAddressId = val);
                              },
                              title: Text(addr['name'] ?? ''),
                              subtitle: Text(
                                "${addr['street']}, ${addr['city']}, ${addr['state']}, ${addr['postalCode']}, ${addr['country']}",
                              ),
                            ),
                          )),
                    const SizedBox(height: 24),
                    Text('Total: ₹$total',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting || products.isEmpty
                            ? null
                            : submitOrder,
                        child: isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
