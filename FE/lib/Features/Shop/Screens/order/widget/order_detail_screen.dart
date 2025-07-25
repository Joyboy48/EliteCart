import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/local_storage/storage_utility.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map order;
  final VoidCallback? onOrderCancelled;
  const OrderDetailScreen(
      {super.key, required this.order, this.onOrderCancelled});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool isCancelling = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final items = widget.order['items'] ?? [];
    List<Map<String, dynamic>> fetched = [];
    for (var id in items) {
      final response = await http
          .get(Uri.parse('${ApiConstants.baseUrl}/products/product/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        fetched.add(data);
      }
    }
    setState(() {
      products = fetched;
      isLoading = false;
    });
  }

  Future<void> cancelOrder() async {
    setState(() => isCancelling = true);
    final orderId = widget.order['_id'];
    final token = await LocalStorage().getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to cancel orders.')),
      );
      setState(() => isCancelling = false);
      return;
    }
    try {
      final response = await http.patch(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId/cancel'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled.')),
        );
        setState(() {
          widget.order['status'] = 'Cancelled';
        });
        if (widget.onOrderCancelled != null) {
          widget.onOrderCancelled!();
        }
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel order: \\${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isCancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final orderId = order['_id']?.toString() ?? '';
    final status = order['status'] ?? 'Pending';
    final orderDate = order['orderDate'] != null
        ? DateFormat('dd MMM, yyyy').format(DateTime.parse(order['orderDate']))
        : '';
    final shippingDate = order['shippingDate'] != null
        ? DateFormat('dd MMM, yyyy')
            .format(DateTime.parse(order['shippingDate']))
        : '';
    final total = order['totalAmount'] ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Text('Order ID: #$orderId',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Status: $status',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Order Date: $orderDate'),
                  Text('Shipping Date: $shippingDate'),
                  const SizedBox(height: 16),
                  Text('Total: ₹$total',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Divider(height: 32),
                  Text('Items:',
                      style: Theme.of(context).textTheme.titleMedium),
                  ...products.map((product) => ListTile(
                        leading: product['images'] != null &&
                                product['images'].isNotEmpty
                            ? Image.network(product['images'][0],
                                width: 48, height: 48, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 48),
                        title: Text(product['name'] ?? 'Product'),
                        subtitle: Text('₹${product['price'] ?? ''}'),
                      )),
                  if (status == 'Pending')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: isCancelling ? null : cancelOrder,
                        child: isCancelling
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Cancel Order'),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
